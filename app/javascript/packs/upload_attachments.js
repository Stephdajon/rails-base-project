const upload_image = document.querySelector('.upload-image')
const preview_image = document.querySelector('.preview-image')

upload_image.addEventListener('change', function(e) {
  const file = e.target.files[0];
  preview_image.src = URL.createObjectURL(file)
})


const upload_video = document.querySelector('.upload-video')
const preview_video = document.querySelector('.preview-video')

upload_video.addEventListener('change', function(e) {
  const file = e.target.files[0];
  preview_video.src = URL.createObjectURL(file)
})
