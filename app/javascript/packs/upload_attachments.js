const upload_image = document.querySelector('.upload-image')
const preview_image = document.querySelector('.preview-image')

const removeProgressElement = () => {
  const directUploadProgress = document.querySelectorAll('.direct-upload')
  if (directUploadProgress){
    Array.from(directUploadProgress).forEach(function(element) {
      element.remove()
      console.log("ERROR")
    })
  }
}

upload_image.addEventListener('change', function(e) {
  const file = e.target.files[0];
  preview_image.src = URL.createObjectURL(file)

  removeProgressElement();
})


const upload_video = document.querySelector('.upload-video')
const preview_video = document.querySelector('.preview-video')

upload_video.addEventListener('change', function(e) {
  const file = e.target.files[0];
  preview_video.src = URL.createObjectURL(file)

  removeProgressElement();
})
