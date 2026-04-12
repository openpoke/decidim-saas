import TomSelect from "tom-select/dist/cjs/tom-select.popular";

const initMunicipalitySelect = () => {
  const el = document.querySelector('[name="user[select_fields][municipality_region_province]"]');
  if (!el || el.tomselect) return;

  const currentValue = el.value;

  fetch("/comuni_regioni_province.json")
    .then((r) => r.json())
    .then((data) => {
      const options = data
        .filter((row) => row["Comune"]?.trim())
        .map((row) => {
          const comune = row["Comune"].trim();
          const provincia = (row["Provincia"] || "").trim();
          const regione = (row["Regione"] || "").trim();
          const label = [comune, provincia, regione].filter(Boolean).join(" - ");
          const value = JSON.stringify({ comune, regione, provincia });
          return { label, value };
        });

      const ts = new TomSelect(el, {
        valueField: "value",
        labelField: "label",
        searchField: "label",
        options,
        allowEmptyOption: true,
        maxItems: 1,
        create: false,
        placeholder: "Select your municipality"
      });

      if (currentValue) {
        ts.setValue(currentValue, true);
      }
    });
};

document.addEventListener("DOMContentLoaded", initMunicipalitySelect);
document.addEventListener("turbolinks:load", initMunicipalitySelect);
document.addEventListener("turbo:load", initMunicipalitySelect);
