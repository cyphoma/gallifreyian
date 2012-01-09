(function(){
  $(document).ready(function() {
    var onI18Keys = $('#i18n_keys')[0];
    if (!onI18Keys) return;

    $('.i18n-section').click(function(event) {
      event.preventDefault();

      var oldVal = $('#search_section').val();
      var newVal = $(this).data('term');

      if (oldVal == newVal) {
        $(this).removeClass('selected');
        $('#search_section').val('');
      } else {
        $('.i18n-section').removeClass('selected');
        $(this).addClass('selected');
        $('#search_section').val(newVal);
      }
    });
  });
})();
