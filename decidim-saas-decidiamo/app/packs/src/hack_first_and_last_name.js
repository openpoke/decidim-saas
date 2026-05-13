function bindNameSync() {
  const firstNameInput = document.querySelector("#registration_user_text_fields_first_name");
  const lastNameInput = document.querySelector("#registration_user_text_fields_last_name");
  const hiddenNameInput = document.querySelector("#registration_user_name_hidden");

  if (!firstNameInput || !lastNameInput || !hiddenNameInput) return;

  firstNameInput.addEventListener("input", syncName);
  lastNameInput.addEventListener("input", syncName);

  function syncName() {
    const firstName = firstNameInput.value.trim();
    const lastName = lastNameInput.value.trim();
    hiddenNameInput.value = `${firstName} ${lastName}`.trim();
  }
}

document.addEventListener("DOMContentLoaded", bindNameSync);
document.addEventListener("turbolinks:load", bindNameSync);
document.addEventListener("turbo:load", bindNameSync);
