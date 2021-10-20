const textField = document.getElementById('search-field')


textField.addEventListener('input', function() {
  const username = this.value
  console.log(username)
  
  $.ajax({
    type: "GET",
    url: "/teachers/search",
    data: { username: username } 
  });
})





