function isTagExists(tagName) {
  let hiddenTags = document.getElementById("hidden_record_tags")
  return hiddenTags.value.split(',').indexOf(tagName.trim())
}

function addNewTag(tagName) {
  isTagExists(tagName)
  tagName = tagName.trim()

  if (tagName.length !== 0 && isTagExists(tagName) == -1) {
    let tags = document.getElementById("record_tags_group")
    let tagDeleteBtn = document.createElement("BUTTON")
    let tagSpan = document.createElement("SPAN")

    tagDeleteBtn.classList = "delete is-small delete_record_tag"

    tagSpan.classList = "tag is-info"
    tagSpan.innerHTML = tagName
    tagSpan.appendChild(tagDeleteBtn)

    tags.appendChild(tagSpan)
    tags.appendChild(document.createTextNode (" "));

    addTagToHiddenInput(tagName)
  }
}

function addTagToHiddenInput(tagName) {
  let hiddenTags = document.getElementById("hidden_record_tags")
  let hiddenTagsValues = hiddenTags.value

  if (hiddenTagsValues.length !== 0) {
    hiddenTagsValues = hiddenTagsValues.split(',')
  } else {
    hiddenTagsValues = []
  }

  hiddenTagsValues.push(tagName)
  hiddenTags.value = hiddenTagsValues.join(',')
}

function removeTagFromHiddenInput(tagName) {
  var hiddenTags = document.getElementById("hidden_record_tags")
  var hiddenTagsValues = hiddenTags.value.split(',')

  hiddenTagsValues = hiddenTagsValues.filter(function(e){ return e !== tagName.trim() })
  hiddenTags.value = hiddenTagsValues.join(',')
}

document.addEventListener("keydown", function(event) {
  let activeEl = document.activeElement

  if (activeEl.id === "record_tags" && event.keyCode === 13) {
    event.preventDefault()

    addNewTag(activeEl.value)
    activeEl.value = ""
  }
})

document.getElementById("record_tags_group").addEventListener("click", function(event){
  if (event.target.classList.contains("delete_record_tag")) {
    event.preventDefault()
    event.target.parentNode.remove()

    removeTagFromHiddenInput(event.target.parentNode.innerText)
  }
})
