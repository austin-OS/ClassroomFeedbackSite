// Menu manipulation

// Add toggle listeners to listen for clicks.
$(document).on("turbo:load", function() {
  $("#account").on("click", function (event) {
    event.preventDefault();
    $("#dropdown-menu").toggleClass("active");
  });
});
