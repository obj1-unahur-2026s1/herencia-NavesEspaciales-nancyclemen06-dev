
class Naves{
  var direccion //property hace 2 metodos, el de consulta "method direccion(){ return direccion}" y uno asi "method direccion(cantidad){direccion = direccion + cantidad}"
  var velocidad 
  var combustible 

  method acelerar(kilometros){
    velocidad = (velocidad + kilometros).min(100000)
  }
  
  method desacelerar(kilometros){
    velocidad = (velocidad - kilometros).max(0)
  }

  method irHaciaElSol(){
    direccion = 10
  }

  method escaparDelSol(){
    direccion = -10
  }

  method ponerseParaleloAlSol(){
    direccion = 0
  }

  method acercarseUnPocoAlSol(){
    direccion = (direccion + 1).min(10)
  }

  method alejarseUnPocoDelSol(){
    direccion = (direccion - 1).max(-10)
  }

  method prepararViaje(){
    self.cargarComustible(30000)
    self.acelerar(5000)
  }

  method cargarComustible(litros){
    combustible = combustible + litros
  }

  method descargarCombustible(litros){
    combustible = (combustible - litros).max(0)
  }

  method estaTranquila(){
    return (combustible > 4000) && (velocidad < 12000)
  }

  method recibirAmenaza(){
    self.escapar()
    self.avisar()
  }

  method escapar(){}

  method avisar(){}

  method estaRelajada(){
    return self.estaTranquila() && self.tienePocaActividad()
  }

  method tienePocaActividad(){}

}

class NavesBaliza inherits Naves {
  var colorBaliza = "rojo" 
  const coloresQueTuvo = []

  method cambiarColorDeBaliza(colorNuevo) {
    colorBaliza = colorNuevo
    coloresQueTuvo.add(colorBaliza)
  }

  override method prepararViaje(){
    super()
    self.cambiarColorDeBaliza("verde")
    self.ponerseParaleloAlSol()
  }

  override method estaTranquila(){
    return super() && colorBaliza != "rojo"
  }

  override method escapar(){
    self.irHaciaElSol()
  }

  override method avisar(){
    self.cambiarColorDeBaliza("rojo")
  }

  override method tienePocaActividad(){
    return super() && (coloresQueTuvo.size() == 1)
  }

}

class NavesPasajeros inherits Naves {
  const pasajeros
  var racionComida = 0
  var racionBebida = 0

  method cargarComida(cantidad){
    racionComida = racionComida + cantidad
  }

  method descargarComida(cantidad){
    racionComida = (racionComida - cantidad).max(0)
  }

  method cargarBebida(cantidad){
    racionBebida = racionBebida - cantidad
  }

  method descargarBebida(cantidad){
    racionBebida = (racionBebida - cantidad).max(0)
  }

  override method prepararViaje(){
    super()
    self.cargarComida(4 * pasajeros)
    self.cargarBebida(6 * pasajeros)
    self.acercarseUnPocoAlSol()
  }

  override method escapar(){
    velocidad = velocidad * 2
  }

  override method avisar(){
    racionComida = (racionComida - 1).max(0) * pasajeros
    racionBebida = (racionBebida - 2).max(0) * pasajeros
  }

  override method tienePocaActividad(){
    return super() && racionComida < 50
  }
}

class NaveCombate inherits Naves {
  var estaInvisible = true
  var hayMisilesDesplegados = true
  const mensajesEmitidos = [] 

  method ponerseVisible() {
    estaInvisible = false
  }

  method ponerseInvisible() {
    estaInvisible = true
  }

  method estaInvisible(){
    return estaInvisible
  }

  method desplegarMisiles(){
    hayMisilesDesplegados = true
  }

  method replegarMisiles(){
    hayMisilesDesplegados = false
  }

  method misilesDesplegados(){
    return hayMisilesDesplegados
  }

  method emitirMensaje(mensaje){
    mensajesEmitidos.add(mensaje)
    return mensaje
  }

  method mensajesEmitidos() {
    return mensajesEmitidos.size()
  }

  method primerMensajeEmitido() {
    return mensajesEmitidos.first()
  }

  method ultimoMensajeEmitido() {
    return mensajesEmitidos.last()
  }

  method esEscueta() {
    return mensajesEmitidos.any({m => m.length() > 30})
  }

  method emitioMensaje(unMensaje) {
    return mensajesEmitidos.contains({unMensaje})
  }

  override method prepararViaje(){
    super()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitirMensaje("Saliendo en misión")
  }

  override method estaTranquila(){
    return super() && not hayMisilesDesplegados
  }

  override method escapar(){
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }

  override method avisar(){
    self.emitirMensaje("Amenaza recibida")
  }
}

class NaveHospital inherits NavesPasajeros {
  var quirofanoPreparado = true

  method prepararQuirofano(){
    quirofanoPreparado = true
  }

  override method estaTranquila(){
    return super() && not quirofanoPreparado
  }

  override method recibirAmenaza(){
    super()
    self.prepararQuirofano()
  }
}

class NaveComabateSigilosa inherits NaveCombate {

  override method estaTranquila(){
    return super() && not estaInvisible
  }

  override method escapar(){
    super()
    self.desplegarMisiles()
    estaInvisible = true
  }
}