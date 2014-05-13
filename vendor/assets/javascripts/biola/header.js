$('#biolaHeader .more > button').on('click', function(){
  $(this).parent().toggleClass('active');
  $('#biolaHeader .nav-header').toggleClass('active');
});