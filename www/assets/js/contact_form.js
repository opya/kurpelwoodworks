var contact_form = document.getElementById("contact_form");

if(contact_form.addEventListener){
  contact_form.addEventListener("submit", contact_form_callback, false);
}

function contact_form_callback(e) {
  e.preventDefault();

  hide_allerts(true);

  console.log(e.target);
}

function hide_allerts(state) {
  toggle_contact_form_name_allerts(state);
  toggle_contact_form_email_allerts(state);
  toggle_contact_form_phone_allerts(state);
}

function toggle_contact_form_name_allerts(state) {
  toggle_input_alerts(state, "name");
  console.log(state, "toggle name allerts");
}

function toggle_contact_form_email_allerts(state) {
  toggle_input_alerts(state, "email");
  console.log(state, "toggle email allerts");
}

function toggle_contact_form_phone_allerts(state) {
  toggle_input_alerts(state, "phone");
  console.log(state, "toggle phone allerts");
}

function toggle_input_alerts(state, input_id) {
  console.log(state, input_id, "toggle input allerts");
}
