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
