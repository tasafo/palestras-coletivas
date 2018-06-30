jQuery(function($) {
   $('.dropdown-toggle').dropdown();

   $(".date").mask("99/99/9999");
   $(".fone").mask("(99) 99999999?9");
   $(".cep").mask("99999-999");
   $(".hour").mask("99:99");
   $(".cpf").mask("999.999.999-99");
   $(".cnpj").mask("99.999.999/9999-99");
});

$.each(document.querySelectorAll('.my-surface'), function(i, el){
  mdc.ripple.MDCRipple.attachTo(el);
});

let drawer = new mdc.drawer.MDCTemporaryDrawer(document.querySelector('.mdc-drawer--temporary'));
document.querySelector('.menu-button').addEventListener('click', () => drawer.open = true);

const container = document.querySelector('#main-container')

let page = 1;

container.addEventListener('scroll', () => {
  if (container.scrollTop + container.clientHeight >= container.scrollHeight) {
    $.ajax({
      url: '/events_ajax?page=' + page,
      success: function(res){
        $('.container').append(res);
        page = ++page;
      }
    })
  }
})

$('#main-container').on('click', '.custom-card', function(){
  $('#main-container').addClass('animated fadeOutDown');
  $('.mdc-linear-progress').show();
})
