import { Controller } from "@hotwired/stimulus"

// Modal usando <dialog> nativo — sem dependência de CSS de transição.
// Uso: data-controller="modal" no wrapper,
//      data-action="modal#open" no gatilho,
//      data-modal-target="dialog" no elemento <dialog>.
export default class extends Controller {
  static targets = ["dialog"]

  open() {
    this.dialogTarget.showModal()
  }

  close() {
    this.dialogTarget.close()
  }

  // Fecha ao clicar fora do painel (no backdrop do <dialog>)
  closeOnBackdrop(event) {
    const rect = this.dialogTarget.getBoundingClientRect()
    const clickedInside =
      rect.top <= event.clientY &&
      event.clientY <= rect.top + rect.height &&
      rect.left <= event.clientX &&
      event.clientX <= rect.left + rect.width
    if (!clickedInside) this.dialogTarget.close()
  }
}
