/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

import React from 'react';
import PropTypes from 'prop-types';

import EditDueDateStep from '../EditDueDateStep';

const EditStartDateStep = React.memo(({ cardId, onBack, onClose }) => (
  <EditDueDateStep
    cardId={cardId}
    field="startDate"
    title="common.editStartDate"
    onBack={onBack}
    onClose={onClose}
  />
));

EditStartDateStep.propTypes = {
  cardId: PropTypes.string.isRequired,
  onBack: PropTypes.func,
  onClose: PropTypes.func.isRequired,
};

EditStartDateStep.defaultProps = {
  onBack: undefined,
};

export default EditStartDateStep;
