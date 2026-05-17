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

const DAY_IN_MILLISECONDS = 24 * 60 * 60 * 1000;
const GANTT_DURATION_IN_MILLISECONDS = 5 * DAY_IN_MILLISECONDS;
const ASSIGNEE_COLORS_TOTAL = 8;

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

const toGanttTask = (card) => {
  if (!card || !card.dueDate) {
    return null;
  }

  const endDate = new Date(card.dueDate);
  if (Number.isNaN(endDate.getTime())) {
    return null;
  }

  const startDate = new Date(endDate.getTime() - GANTT_DURATION_IN_MILLISECONDS);
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
    name: card.primaryUser ? `${card.primaryUser.name} · ${card.name}` : card.name,
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

    chartRef.current = new Gantt(wrapperNode, tasks, {
      view_mode: 'Week',
      view_mode_select: true,
      readonly: true,
      readonly_dates: true,
      readonly_progress: true,
      popup: false,
      scroll_to: 'start',
      on_click: (task) => {
        dispatch(push(Paths.CARDS.replace(':id', task.id)));
      },
    });

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
