require.context("../images", true)


document.addEventListener("DOMContentLoaded", () => {
  const cleanClothes = document.querySelector(".clean-clothes-organization-fields")
  if (cleanClothes) {
    const selector = cleanClothes.querySelector('[name="user[select_fields][participant_type]"]')
    const fields = [
      cleanClothes.querySelectorAll('[name="user[select_fields][organization_country]"]'),
      cleanClothes.querySelectorAll('[name="user[select_fields][organization_name]"]'),
      cleanClothes.querySelectorAll('[name="user[select_fields][organization_type]"]'),
      cleanClothes.querySelectorAll('[name="user[text_fields][organization_name]"]'),
      cleanClothes.querySelectorAll('[name="user[boolean_fields][]"]')
    ];

    
    const toggleFields = () => {
      fields.forEach((fieldCollection) => {
        fieldCollection.forEach((field) => {
          if (selector.value === "individual") {
            console.log("hide",field)
            field.closest(".fieldset").classList.add("hidden")
          } else {
            console.log("show",field)
            field.closest(".fieldset").classList.remove("hidden")
          }
        })
      })
    };
    console.log(selector, fields, toggleFields)

    toggleFields();
    selector.addEventListener("change", toggleFields);
  }
})