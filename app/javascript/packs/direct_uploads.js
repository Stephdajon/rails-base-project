const errorMessage = (error) => {
  let errorContent;

  if (error.includes('Status')) {
    const status = error.slice(error.indexOf('Status')).split(" ");
    const statusCode = parseInt(status[status.length - 1])

    if (statusCode === 413) {
      errorContent = 'File is exceeding maximum of 100MB';
    } else if (statusCode === 0) {
      errorContent = 'Something went wrong from our end. Please try again later';
    }
    else {
      errorContent = 'Something went wrong. Please try again';
    }
  } else {
    errorContent = 'Something went wrong. Please try again';
  }

  return errorContent;
}

const removePreviousPendingProgress = () => {
  const directUploadProgress = document.querySelectorAll('.direct-upload--pending')
  if (directUploadProgress){
    Array.from(directUploadProgress).forEach(function(element, index) {
      if (index != 0) {
        element.remove()
      }
    })
  }

  const directUploadComplete = document.querySelectorAll('.direct-upload--complete')
  if (directUploadComplete){
    Array.from(directUploadComplete).forEach(function(element, index) {
      if (index != 0) {
        element.remove()
      }
    })
  }
}

addEventListener("direct-upload:initialize", event => {
  removePreviousPendingProgress();
  const { target, detail } = event
  const { id, file } = detail
  target.insertAdjacentHTML("beforebegin", `
    <div id="direct-upload-${id}" class="direct-upload direct-upload--pending">
      <div id="direct-upload-progress-${id}" class="direct-upload__progress" style="width: 0%"></div>
      <span class="direct-upload__filename"></span>
    </div>
  `)
  target.previousElementSibling.querySelector(`.direct-upload__filename`).textContent = file.name
})

addEventListener("direct-upload:start", event => {
  const { id } = event.detail
  const element = document.getElementById(`direct-upload-${id}`)
  element.classList.remove("direct-upload--pending")
})

addEventListener("direct-upload:progress", event => {
  removePreviousPendingProgress();
  const { id, progress } = event.detail
  const progressElement = document.getElementById(`direct-upload-progress-${id}`)
  progressElement.style.width = `${progress}%`
  document.getElementById('save_lesson').disabled = true;
})


addEventListener("direct-upload:error", event => {
  event.preventDefault()
  const { id, error } = event.detail
  const element = document.getElementById(`direct-upload-${id}`)
  element.classList.add("direct-upload--error")
  element.setAttribute("title", error)

  element.innerHTML = errorMessage(error)
  document.getElementById('save_lesson').disabled = false
})

addEventListener("direct-upload:end", event => {
  const { id } = event.detail
  const element = document.getElementById(`direct-upload-${id}`)
  element.classList.add("direct-upload--complete")
})
