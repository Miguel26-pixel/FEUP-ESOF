exports.parsePoint = (data, obj) => {
  const alerts = data.alerts.map((alertRef) => alertRef.id);

  return {
    ...data,
    alerts,
    id: obj.id,
  };
};
