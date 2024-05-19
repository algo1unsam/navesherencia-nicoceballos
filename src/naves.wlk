class Nave{
	var property velocidad = 0

	method aumentarVelocidad(_cuanto){
		velocidad = (velocidad + _cuanto).min(300000)
	}
	
	method preparar(){
		self.aumentarVelocidad(15000)
	}
	
	method propulsar(){

		self.aumentarVelocidad(15000)

	}
	method encontrarEnemigo(){
		self.recibirAmenaza()
		self.propulsar()
	}
	method recibirAmenaza()
}


class NaveDeCarga inherits Nave {

	
	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000

	override method recibirAmenaza() {
		carga = 0
	}

}
class NavedeCargaRadioactiva inherits NaveDeCarga{
	var property sellada = false
	
	method sellarAlVacio(){
		sellada = true
		velocidad = 0
	}

	override method recibirAmenaza() {
		self.sellarAlVacio()
	}
	override method preparar(){
		self.sellarAlVacio()
		super()
	}
}

class NaveDePasajeros inherits Nave{

	
	var property alarma = false
	const cantidadDePasajeros = 0

	method tripulacion() = cantidadDePasajeros + 4

	method velocidadMaximaLegal() = 300000 / self.tripulacion() - if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaLegal() or alarma

	override method recibirAmenaza() {
		alarma = true
	}

}

class NaveDeCombate inherits Nave{

	var property modo = reposo
	const property mensajesEmitidos = []

	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = velocidad < 10000 and modo.invisible()

	override method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}

	override method preparar(){
		super()
		modo.preparar(self)
	}
}
class EstadoDeNaveCombate{
	method preparar(nave){
		nave.emitirMensaje(self.mensajeDePreparacion())
		nave.modo(ataque)
	}
	method mensajeDePreparacion()
}

object reposo inherits EstadoDeNaveCombate{

	method invisible() = false

	method recibirAmenaza(nave) {
		nave.emitirMensaje("¡RETIRADA!")
	}
	override method mensajeDePreparacion(){
		return("Saliendo en misión")
		
	}
}

object ataque inherits EstadoDeNaveCombate{

	method invisible() = true

	method recibirAmenaza(nave) {
		nave.emitirMensaje("Enemigo encontrado")
	}
	override method mensajeDePreparacion(){
		return("Volviendo a la base")
	}

}


