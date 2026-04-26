import { Controller } from "@hotwired/stimulus"

// Modal genérico reutilizável.
// Uso: data-controller="modal" no wrapper,
//      data-action="modal#open" no gatilho,
//      data-modal-target="overlay" no elemento raiz do modal.
export default class extends Controller {
  static targets = ["overlay"]

  connect() {
    this._onKeydown = this._onKeydown.bind(this)
  }

  open() {
    this.overlayTarget.classList.add("is-open")
    document.addEventListener("keydown", this._onKeydown)
    document.body.style.overflow = "hidden"
  }

  close() {
    this.overlayTarget.classList.remove("is-open")
    document.removeEventListener("keydown", this._onKeydown)
    document.body.style.overflow = ""
  }

  closeOnBackdrop(event) {
    if (event.target === this.overlayTarget) this.close()
  }

  _onKeydown(event) {
    if (event.key === "Escape") this.close()
  }
}
