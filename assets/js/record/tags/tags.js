function addNewTag(tagName) {
  let tags = document.getElementById("record_tags")
  let tagDeleteBtn = document.createElement("BUTTON")
  let tagSpan = document.createElement("SPAN")

  tagDeleteBtn.classList = "delete is-small delete_record_tag"

  tagSpan.classList = "tag is-info"
  tagSpan.innerHTML = tagName
  tagSpan.appendChild(tagDeleteBtn)

  tags.appendChild(tagSpan)
  tags.appendChild(document.createTextNode (" "));
}

function removeTag(tagName) {
}

document.addEventListener("keydown", function(event) {
  const activeEl = document.activeElement

  if (activeEl.id === "record_tags_input" && event.keyCode === 13) {
    event.preventDefault()

    console.log(activeEl)
    addNewTag(activeEl.value)
    activeEl.value = ""
  }
})

document.getElementById("record_tags").addEventListener("click", function(event){
  if (event.target.classList.contains("delete_record_tag")) {
    event.preventDefault()
    event.target.parentNode.remove()
  }
})
