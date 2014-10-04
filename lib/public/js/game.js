$(function(){

  // 初期状態
  $("#nav-game").addClass("active");

  $("#client").click(
    function(){
      var to = $("#to").val();
      var subject = $("#subject").val();
      if (subject.length === 0)  {
        $("#subject-form").addClass("has-error");
      } else {
        $("#subject-form").removeClass("has-error");
        location.href = getHref(to, subject);
      }
    }
  );

  getHref = function(to, subject) {
    return "mailto:" + to + "?subject="+ subject;
  };

});
