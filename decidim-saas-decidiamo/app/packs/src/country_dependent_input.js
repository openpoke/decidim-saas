import createFieldDependentInputs from "src/decidim/admin/field_dependent_inputs.component";

const initCountryDependentInput = () => {
  const el = $('[name="user[select_fields][municipality_region_province]"]');
  if (!el.length) return;

  createFieldDependentInputs({
    controllerField: el,
    wrapperSelector: "form",
    dependentFieldsSelector: 'label:has(select[name="user[country]"])',
    dependentInputSelector: "select",
    enablingCondition: ($field) => $field.val() === "Risiedo all'estero"
  });
};

document.addEventListener("DOMContentLoaded", initCountryDependentInput);
document.addEventListener("turbolinks:load", initCountryDependentInput);
document.addEventListener("turbo:load", initCountryDependentInput);
