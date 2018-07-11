jQuery(function($) {
   $('.dropdown-toggle').dropdown();

   $(".fone").mask("(99) 99999999?9");
   $(".cep").mask("99999-999");
   $(".hour").mask("99:99");
   $(".cpf").mask("999.999.999-99");
   $(".cnpj").mask("99.999.999/9999-99");
});

$.each(document.querySelectorAll('.my-surface'), function(i, el){
  mdc.ripple.MDCRipple.attachTo(el);
});

$.each(document.querySelectorAll('.mdc-text-field'), function(i, el){
  const textField = new mdc.textField.MDCTextField(el);
});

let drawer = new mdc.drawer.MDCTemporaryDrawer(document.querySelector('.mdc-drawer--temporary'));
document.querySelector('.menu-button').addEventListener('click', () => drawer.open = true);

$('#main-container').on('click', '.custom-card, .link-effect', function(){
  $('#main-container').addClass('animated fadeOutDown');
  $('.mdc-linear-progress').show();
});

$(".container-grid").height( $(window).height() );

var buttons = document.querySelectorAll('.mdc-button, .mdc-fab');
for (var i = 0, button; button = buttons[i]; i++) {
  mdc.ripple.MDCRipple.attachTo(button);
}

var nodes = document.querySelectorAll('.mdc-icon-toggle');
for (var i = 0, node; node = nodes[i]; i++) {
  mdc.iconToggle.MDCIconToggle.attachTo(node);
}

var checkboxes = document.querySelectorAll('.mdc-checkbox');
for (var i = 0, checkbox; checkbox = checkboxes[i]; i++) {
  new mdc.checkbox.MDCCheckbox(checkbox);
}

var selects = document.querySelectorAll('.mdc-select');
for (var i = 0, select; select = selects[i]; i++) {
  new mdc.select.MDCSelect(select);
}

var radios = document.querySelectorAll('.mdc-radio');
for (var i = 0, radio; radio = radios[i]; i++) {
  new mdc.radio.MDCRadio(radio);
}

var interactiveListItems = document.querySelectorAll('.mdc-list-item');
for (var i = 0, li; li = interactiveListItems[i]; i++) {
  mdc.ripple.MDCRipple.attachTo(li);
  // Prevent link clicks from jumping demo to the top of the page
  li.addEventListener('click', function(evt) {
    // evt.preventDefault();
  });
}
