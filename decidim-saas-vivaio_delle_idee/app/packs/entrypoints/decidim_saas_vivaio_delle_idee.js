import "stylesheets/decidim_saas_vivaio_delle_idee.scss";
import TomSelect from "tom-select/dist/cjs/tom-select.popular";

document.addEventListener("turbo:load", () => {
  const el = document.querySelector('[name="user[select_fields][municipality_region_province]"]');
  if (!el || el.tomselect) return;

  const ts = new TomSelect(el, {
    allowEmptyOption: true,
    maxItems: 1,
    create: false,
    placeholder: "Select municipality / region / province"
  });

  if (!el.value) ts.clear(true);
});
