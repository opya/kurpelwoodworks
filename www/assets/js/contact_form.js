var contact_form_id = "contact_form";
var contact_form = document.getElementById(contact_form_id);

toggle_form_alerts(false);

if(contact_form.addEventListener){
  contact_form.addEventListener("submit", contact_form_callback, false);
}

function contact_form_callback(e) {
  e.preventDefault();
  toggle_form_alerts(false);

  if (valid_name() && valid_phone_or_email() && valid_message()) {
    e.target.submit();
  }
}

function valid_name() {
  var name_input = document.getElementById('contact_form_name').getElementsByTagName('input')[0];

  if (name_input.value.length == 0) {
    toggle_input_alerts('contact_form_name', true);
    return false;
  } else {
    return true;
  }
}

function valid_phone() {
  var phone_input = document.getElementById('contact_form_phone').getElementsByTagName('input')[0];

  if (phone_input.validity.valid) {
    return true;
  } else {
    toggle_input_alerts('contact_form_phone', true);
    return false;
  }
}

function valid_email() {
  var email_input = document.getElementById('contact_form_email').getElementsByTagName('input')[0];

  if (email_input.validity.valid) {
    return true;
  } else {
    toggle_input_alerts('contact_form_email', true);
    return false;
  }
}

function valid_message() {
  var name_input = document.getElementById('contact_form_message').getElementsByTagName('textarea')[0];

  if (name_input.value.length == 0) {
    toggle_textarea_alerts(true);
    return false;
  } else {
    return true;
  }
}

function valid_phone_or_email() {
  var phone_input = document.getElementById('contact_form_phone').getElementsByTagName('input')[0];
  var email_input = document.getElementById('contact_form_email').getElementsByTagName('input')[0];

  if (phone_input.value.length == 0 && email_input.value.length == 0) {
    toggle_input_alerts('contact_form_email', true);
    toggle_input_alerts('contact_form_phone', true);

    return false;
  }

  if (!valid_phone()) {
    return false
  }

  if(!valid_email()) {
    return false;
  }

  return true;
}

function toggle_form_alerts(state) {
  toggle_input_alerts('contact_form_name', state);
  toggle_input_alerts('contact_form_email', state);
  toggle_input_alerts('contact_form_phone', state);
  toggle_textarea_alerts(state);
}

function toggle_input_alerts(input_name, state) {
  var form_input = document.getElementById(input_name);
  
  if (form_input && typeof form_input != undefined) {
    if (!state) {
      form_input.getElementsByTagName('input')[0].classList.remove('is-danger')
      form_input.getElementsByTagName('span')[1].classList.add('is-hidden');
      form_input.getElementsByTagName('p')[0].classList.add('is-hidden');
    } else {
      form_input.getElementsByTagName('input')[0].classList.add('is-danger')
      form_input.getElementsByTagName('span')[1].classList.remove('is-hidden');
      form_input.getElementsByTagName('p')[0].classList.remove('is-hidden');
    }
  }
}

function toggle_textarea_alerts(state) {
  var form_input = document.getElementById('contact_form_message');

  if (form_input && typeof form_input != undefined) {
    if (!state) {
      form_input.getElementsByTagName('textarea')[0].classList.remove('is-danger')
      form_input.getElementsByTagName('p')[0].classList.add('is-hidden');
    } else {
      form_input.getElementsByTagName('textarea')[0].classList.add('is-danger')
      form_input.getElementsByTagName('p')[0].classList.remove('is-hidden');
    }
  }
}
