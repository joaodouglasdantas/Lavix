import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["picker", "text"]

  connect() {
    // Garante que ambos os campos iniciem com o mesmo valor
    const initial = this.textTarget.value.trim()
    if (initial && /^#[0-9A-Fa-f]{6}$/.test(initial)) {
      this.pickerTarget.value = initial
    } else if (initial && /^[0-9A-Fa-f]{6}$/.test(initial)) {
      // Valor sem # no banco (legado) — normaliza
      const normalized = `#${initial}`
      this.pickerTarget.value = normalized
      this.textTarget.value = normalized
    }
  }

  // Usuário escolheu uma cor no seletor nativo
  pickerChanged() {
    this.textTarget.value = this.pickerTarget.value
  }

  // Usuário digitou no campo de texto
  textChanged() {
    const raw = this.textTarget.value.trim()
    const hex = raw.startsWith("#") ? raw : `#${raw}`

    if (/^#[0-9A-Fa-f]{6}$/.test(hex)) {
      this.pickerTarget.value = hex
    }
  }
}
