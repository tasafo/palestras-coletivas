jQuery(function($) {
   $('.dropdown-toggle').dropdown();

   $(".date").mask("99/99/9999");
   $(".fone").mask("(99) 99999999?9");
   $(".cep").mask("99999-999");
   $(".hour").mask("99:99");
   $(".cpf").mask("999.999.999-99");
   $(".cnpj").mask("99.999.999/9999-99");
});