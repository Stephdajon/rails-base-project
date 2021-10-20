const textField = document.getElementById('search-field')


textField.addEventListener('input', function() {
  const username = this.value

  $.ajax({
    type: "GET",
    url: "/teacher/search",
    data: { username: username } 
  });
})
