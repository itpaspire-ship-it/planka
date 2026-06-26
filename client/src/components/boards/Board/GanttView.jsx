/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

import React, { useEffect, useMemo, useRef } from 'react';
import PropTypes from 'prop-types';
import { useDispatch } from 'react-redux';
import { useTranslation } from 'react-i18next';
import { Icon } from 'semantic-ui-react';
import Gantt from 'frappe-gantt';
// frappe-gantt does not export its stylesheet through package exports.
// eslint-disable-next-line import/no-relative-packages
import '../../../../node_modules/frappe-gantt/dist/frappe-gantt.css';
import { push } from '../../../lib/redux-router';

import Paths from '../../../constants/Paths';

import styles from './GanttView.module.scss';

const ASSIGNEE_COLORS_TOTAL = 8;

const AVATAR_COLORS = ['#2ecc71', '#3498db', '#8e44ad', '#e67e22', '#e74c3c', '#1abc9c', '#2c3e50'];

const formatDate = (date) => {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');

  return `${year}-${month}-${day}`;
};

const getProgress = (card) => {
  if (card.tasks.length === 0) {
    return card.isDueCompleted || card.isClosed ? 100 : 0;
  }

  const completedTasksTotal = card.tasks.filter((task) => task.isCompleted).length;

  return Math.round((completedTasksTotal / card.tasks.length) * 100);
};

const getAssigneeColorIndex = (userId) => {
  if (!userId) {
    return null;
  }

  return (
    Array.from(userId).reduce((sum, character) => sum + character.charCodeAt(0), 0) %
    ASSIGNEE_COLORS_TOTAL
  );
};

const getUserInitials = (name) => {
  const words = name
    .trim()
    .split(/[\s-]+/)
    .filter(Boolean);

  if (words.length === 0) {
    return '';
  }

  if (words.length === 1) {
    return [...words[0]].slice(0, 2).join('');
  }

  return words
    .slice(0, 2)
    .map((word) => [...word][0])
    .join('');
};

const escapeSvgText = (text) =>
  text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
const getUserColor = (name) => {
  let sum = 0;
  for (let i = 0; i < name.length; i += 1) {
    sum += name.charCodeAt(i);
  }

  return AVATAR_COLORS[sum % AVATAR_COLORS.length];
};

const getUserThumbnail = (user) => {
  const avatarUrl = user.avatar ? user.avatar.thumbnailUrls.cover180 : user.gravatarUrl;

  if (avatarUrl) {
    return avatarUrl;
  }

  const color = getUserColor(user.name);
  const initials = escapeSvgText(getUserInitials(user.name));
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25"><rect width="25" height="25" rx="12.5" fill="${color}"/><text x="50%" y="50%" dy="0.35em" text-anchor="middle" fill="#fff" font-family="Arial, Helvetica, sans-serif" font-size="9" font-weight="700">${initials}</text></svg>`;

  return `data:image/svg+xml;charset=utf-8,${encodeURIComponent(svg)}`;
};

const positionGanttLabels = (wrapperNode) => {
  wrapperNode.querySelectorAll('.bar-wrapper').forEach((barWrapperNode) => {
    const barNode = barWrapperNode.querySelector('.bar');
    const labelNode = barWrapperNode.querySelector('.bar-label');

    if (!barNode || !labelNode) {
      return;
    }

    const imageNode = barWrapperNode.querySelector('.bar-img');
    const imageMaskNode = barWrapperNode.querySelector('.img_mask');
    const barX = Number(barNode.getAttribute('x'));
    const barY = Number(barNode.getAttribute('y'));
    const barHeight = Number(barNode.getAttribute('height'));
    let labelX = barX + 10;

    if (imageNode) {
      const imageSize = Number(imageNode.getAttribute('width'));
      const imageX = barX + 6;
      const imageY = barY + (barHeight - imageSize) / 2;

      imageNode.setAttribute('x', imageX);
      imageNode.setAttribute('y', imageY);

      if (imageMaskNode) {
        imageMaskNode.setAttribute('x', imageX);
        imageMaskNode.setAttribute('y', imageY);
      }

      labelX = imageX + imageSize + 10;
    }

    labelNode.classList.remove('big');
    labelNode.setAttribute('x', labelX);
    labelNode.setAttribute('y', barY + barHeight / 2);
    labelNode.setAttribute('text-anchor', 'start');
  });
};

const toGanttTask = (card) => {
  if (!card || !card.startDate || !card.dueDate) {
    return null;
  }

  const startDate = new Date(card.startDate);
  if (Number.isNaN(startDate.getTime())) {
    return null;
  }

  const endDate = new Date(card.dueDate);
  if (Number.isNaN(endDate.getTime())) {
    return null;
  }
  const assigneeColorIndex = getAssigneeColorIndex(card.primaryUser && card.primaryUser.id);
  let customClass;

  if (assigneeColorIndex !== null) {
    customClass = `gantt-assignee-color-${assigneeColorIndex}`;
  }

  if (card.isClosed) {
    customClass = customClass ? `${customClass} gantt-task-closed` : 'gantt-task-closed';
  }

  return {
    id: card.id,
    name: card.name,
    ...(card.primaryUser && {
      thumbnail: getUserThumbnail(card.primaryUser),
    }),
    start: formatDate(startDate),
    end: formatDate(endDate),
    progress: getProgress(card),
    custom_class: customClass,
  };
};

const GanttView = React.memo(({ ganttItems }) => {
  const tasks = useMemo(() => ganttItems.map(toGanttTask).filter(Boolean), [ganttItems]);

  const wrapperRef = useRef(null);
  const chartRef = useRef(null);

  const dispatch = useDispatch();
  const [t] = useTranslation();

  useEffect(() => {
    if (!wrapperRef.current || tasks.length === 0) {
      return undefined;
    }

    const wrapperNode = wrapperRef.current;

    wrapperNode.innerHTML = '';

    const updateLabels = () => {
      requestAnimationFrame(() => positionGanttLabels(wrapperNode));
    };

    chartRef.current = new Gantt(wrapperNode, tasks, {
      view_mode: 'Week',
      view_mode_select: true,
      infinite_padding: false,
      readonly: true,
      readonly_dates: true,
      readonly_progress: true,
      popup: false,
      scroll_to: 'start',
      on_click: (task) => {
        dispatch(push(Paths.CARDS.replace(':id', task.id)));
      },
      on_view_change: updateLabels,
    });

    updateLabels();

    return () => {
      chartRef.current = null;
      wrapperNode.innerHTML = '';
    };
  }, [dispatch, tasks]);

  return (
    <div className={styles.wrapper}>
      {tasks.length > 0 ? (
        <div ref={wrapperRef} className={styles.chart} />
      ) : (
        <div className={styles.message}>
          <Icon name="calendar alternate outline" size="huge" className={styles.messageIcon} />
          <div className={styles.messageTitle}>{t('common.noCardsFound')}</div>
          <div className={styles.messageContent}>
            {t('common.timelineDisplayOfCardsWithDueDates')}
          </div>
        </div>
      )}
    </div>
  );
});

GanttView.propTypes = {
  ganttItems: PropTypes.array.isRequired, // eslint-disable-line react/forbid-prop-types
};

export default GanttView;
