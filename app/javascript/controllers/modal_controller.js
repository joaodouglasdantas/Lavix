import { Controller } from "@hotwired/stimulus"

// Modal genérico reutilizável.
// Uso: data-controller="modal" no wrapper,
//      data-action="modal#open" no gatilho,
//      data-modal-target="panel" no elemento do modal,
//      data-modal-target="backdrop" no backdrop.
export default class extends Controller {
  static targets = ["panel", "backdrop"]

  connect() {
    this._onKeydown = this._onKeydown.bind(this)
  }

  open() {
    this.panelTarget.classList.remove("hidden")
    this.backdropTarget.classList.remove("hidden")
    // Pequeno delay para a transição CSS funcionar
    requestAnimationFrame(() => {
      this.backdropTarget.classList.remove("opacity-0")
      this.panelTarget.classList.remove("opacity-0", "scale-95")
    })
    document.addEventListener("keydown", this._onKeydown)
    document.body.style.overflow = "hidden"
  }

  close() {
    this.backdropTarget.classList.add("opacity-0")
    this.panelTarget.classList.add("opacity-0", "scale-95")
    setTimeout(() => {
      this.panelTarget.classList.add("hidden")
      this.backdropTarget.classList.add("hidden")
    }, 200)
    document.removeEventListener("keydown", this._onKeydown)
    document.body.style.overflow = ""
  }

  closeOnBackdrop(event) {
    if (event.target === this.backdropTarget) this.close()
  }

  _onKeydown(event) {
    if (event.key === "Escape") this.close()
  }
}
