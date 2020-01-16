- [SDOSStencil](#sdosstencil)
  - [Introducción](#introducci%c3%b3n)
  - [Instalación](#instalaci%c3%b3n)
    - [Cocoapods](#cocoapods)
    - [Configuración](#configuraci%c3%b3n)
      - [Parametros del script](#parametros-del-script)
  - [Cómo se usa](#c%c3%b3mo-se-usa)
    - [RealmFields](#realmfields)
  - [Dependencias](#dependencias)
  - [Referencias](#referencias)

# SDOSStencil

- Changelog: https://github.com/SDOSLabs/SDOSStencil/blob/master/CHANGELOG.md

## Introducción
SDOSStencil es una herramienta orientada para la generación automática basándonos en ficheros .stencil, para ello se usa Sourcery.
Se ha usado esta forma de generación ya que a veces es necesario generar ciertos recursos para evitar los errores en ejecución y poder detectarlos en tiempo de compilación.

## Instalación

### Cocoapods

Usaremos [CocoaPods](https://cocoapods.org). Hay que añadir la dependencia y el source al `Podfile`:

**Source**:

```ruby
source 'https://github.com/SDOSLabs/cocoapods-specs.git'
```

**Dependencia**:

```ruby
pod 'SDOSStencil', '~> 1.0.0'
```

### Configuración

Vamos a crear un nuevo **target** en el proyecto para realizar un `Build` cada vez que realicemos una modificación o creación de algún modelo de **Realm**, para ello debemos de seguir los siguientes pasos:

1. En Xcode: Pulsar sobre *File*, *New*, *Target*, elegir la opción *Cross-platform*, seleccionar *Aggregate* e indicar el nombre *`RealmFields`*
2. Seleccionar el proyecto, elegir el `TARGET` que acabamos de crear, seleccionar la pestaña de `Build Phases` y pulsar en añadir `New Run Script Phase` en el icono de **`+`** arriba a la izquierda
3. (Opcional) Renombramos el script que nos ha creado por el nombre deseado. Ej: `RealmFields`
4. Copiamos el siguiente script:

```sh
    "${SRCROOT}/Pods/Sourcery/bin/sourcery" --sources "<Path to input files>" --templates "${SRCROOT}/Pods/SDOSStencil/src/Templates/Realm/RealmParser.stencil" --output "<Path to output folder>"
```

- El parametro de `<Path to input files>` es la ruta de la carpeta que contiene nuestros ficheros de entrada, los que va a procesar para generar el codigo.
- El parameteo de `<Path to output folder>` es la ruta de la carpeta donde se van a generar los ficheros autogenerados. Es muy **`IMPORTANTE`** que esta carpeta este creada en nuestro proyecto antes de ejecutar el script.

Un ejemplo de como quedaria este script en un proyecto es el siguiente:

```sh
    "${SRCROOT}/Pods/Sourcery/bin/sourcery" --sources "${SRCROOT}/SDOSStencil/RealmModels" --templates "${SRCROOT}/Pods/SDOSStencil/src/Templates/Realm/RealmParser.stencil" --output "${SRCROOT}/SDOSStencil/Generated/"
```

1. Realizamos un primer `Build` al target que hemos creado. Si todo es correcto, en de la ruta indicada en el parámetro `--output` se generará una carpeta con los ficheros generados. Los ficheros dependen del las plantillas indicadas.
2. Es necesario añadir manualmente estas carpetas y ficheros generados al proyecto, ya que solo tendremos visibilidad de estos desde el `Finder`. Para hacerlo hacer lo siguiente:
   1. Navegar a la carpeta de Xcode donde queramos añadir los nuevos ficheros y pulsar click derecho.
   2. Seleccionar la opción "Add files to `<target>`".
   3. Click en la/las carpetas que nos ha generado y pulsar en **`Add`**.

#### Parametros del script

***
| Parametro   |      Descripción      |  Ejemplo |
|----------|:-------------:|------:|
|**`sources`**|Ruta que queremos que el script analiza para generar recursos automáticos. |`"${SRCROOT}/SDOSStencil/RealmModels"`|
|**`templates`**|Ruta de la carpeta que contiene los `.stencil` que queremos usar (plantillas) o directamente a la plantilla. |`"${SRCROOT}/Pods/SDOSStencil/src/Templates/Realm/"` o `"${SRCROOT}/Pods/SDOSStencil/src/Templates/Realm/RealmParser.stencil"`|
| **`output`** |Ruta donde queremos que se generen los ficheros autogenerados. |`"${SRCROOT}/SDOSStencil/Generated/"`|

***

## Cómo se usa

Cada `stencil` desarrolla sus propias plantillas en base a las que debe generar el código. En este caso todos los ficheros a parsear deben incluir una anotación con el identificador del autogenerado que se va a usar. Esto se va a ver a continuación en el desglose de cada `stencil`.

### RealmFields

`RealmFields` es un stencil orientado para la generación de enumeradores con constantes de las propiedades que tiene un modelo Realm. Esto es útil a la hora de realizar consultas, definir la `PrimaryKey`, ignorar propiedades, etc, porque evitaremos posibles al usar constantes autogeneradas


La plantilla requiere que las clases de Realm cumplan las siguientes reglas (en formato stencil):
```
    {% for type in types.classes|annotated:"RealmFields" %}
```
Esto se traduce a lo siguiente:
  - La entidad debe ser de tipo **`class`** 
  - Debe contener la anotación **`//sourcery:RealmFields`**. La anotación es un comentario justo encima de la declaración de la clase

El siguiente ejemplo cumple las condiciones anteriores:
```swift
//sourcery:RealmFields
class PersonRealm: Object {

    var name = ""
    var identifier = UUID().uuidString
    
    @objc dynamic var avatar: Data? = nil
    
    let dogs = List<DogRealm>()
    
    override class func primaryKey() -> String? {
        return PersonRealm.Attributes.identifier
    }

}
```

Este `stencil` nos va a generar una carpeta dentro de la ruta indicada en el parámetro `--output` del comando, con el nombre de `RealmFields` y dentro un fichero con el nombre de `RealmFields.generated.swift`.

Tiene esta estructura:

```swift
// MARK: - DogRealmAttributes
extension DogRealm {
	enum Attributes {
		static let name = "name"
		static let identifier = "identifier"
	}
}

// MARK: - PersonRealmAttributes
extension PersonRealm {
	enum Attributes {
		static let name = "name"
		static let identifier = "identifier"
		static let avatar = "avatar"
		static let dogs = "dogs"
	}
}

```

## Dependencias
* [Sourcery](https://github.com/krzysztofzablocki/Sourcery) - &gt;= 0.17.0

## Referencias
* https://github.com/SDOSLabs/SDOSStencil
* https://github.com/krzysztofzablocki/Sourcery
* [Guia .stencil](https://cdn.rawgit.com/krzysztofzablocki/Sourcery/master/docs/index.html)