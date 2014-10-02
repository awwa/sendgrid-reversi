$(function(){

  // 初期状態
  $("#nav-game").addClass("active");

  $("#start").click(
    function(){
      location.href = "mailto:" + $("#to").val() + "?subject="+ $("#subject").val();
    }
  );

});
