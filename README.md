- [SDOSStencil](#SDOSStencil)
  - [Introducción](#Introducci%C3%B3n)
  - [Instalación](#Instalaci%C3%B3n)
    - [Cocoapods](#Cocoapods)
    - [Configuración](#Configuraci%C3%B3n)
  - [Cómo se usa](#C%C3%B3mo-se-usa)
    - [RealmFields](#RealmFields)
  - [Dependencias](#Dependencias)
  - [Referencias](#Referencias)

# SDOSStencil

- Changelog: https://github.com/SDOSLabs/SDOSStencil/blob/master/CHANGELOG.md

## Introducción
SDOSStencil es una herramienta orientada para la generación automática basándonos en ficheros .stencil, para ello se usa Sourcery.
Se ha usado esta forma de generación ya que a veces es necesario generar ciertos recursos para evitar los errores en ejecución y poder detectarlos en tiempo de compilación.

## Instalación

Para la instalacion lo vamos a realizar con Cocoapods, como se indica a continuación.

### Cocoapods

Usaremos [CocoaPods](https://cocoapods.org). Hay que añadir la dependencia al `Podfile` y el source de esta:

**Source**:

```ruby
source ‘https://github.com/SDOSLabs/cocoapods-specs.git’
```

**Dependencia**:

```ruby
    pod `SDOSStencil`, `~> 0.0.1`
```

### Configuración

Vamos a crear un nuevo **target** en el proyecto para buildearlo cada vez que realicemos una modificación o creación de algún modelo de **Realm**, para ello debemos de seguir los siguientes pasos:

1. En Xcode: Pulsar sobre *File*, *New*, *Target*, elegir la opción *Cross-platform*, seleccionar *Aggregate* e indicar el nombre *`RealmFields`*
2. Seleccionar el proyecto, elegir el `TARGET` que acabamos de crear, seleccionar la pestaña de `Build Phases` y pulsar en añadir `New Run Script Phase` en el icono de **`+`** arriba a la izquierda
3. (Opcional) Renombramos el script que nos ha creado por el nombre deseado. Ej: `RealmFields`
4. Copiamos el siguiente script:

```sh
    "${SRCROOT}/Pods/Sourcery/bin/sourcery" --sources "${SRCROOT}/SDOSStencil/RealmModels" --templates "${SRCROOT}/Pods/SDOSStencil/src/Templates/Realm/RealmParser.stencil" --output "${SRCROOT}/SDOSStencil/Generated/"
```

***

**`IMPORTANTE`**

La carpeta de `Generated` debe estar creada antes de ejecutar el `script`.

***
| Parametro   |      Descripción      |  Ejemplo |
|----------|:-------------:|------:|
|**`sources`**|Ruta que queremos que el script analiza para generar recursos automáticos. |`"SDOSStencil/RealmModels"`|
|**`templates`**|Ruta de los `.stencil` que queremos usar (plantillas) o directamente a la plantilla. En este caso estamos indicando las plantillas referentes a Realm.|`"${SRCROOT}/Pods/SDOSStencil/src/Templates/Realm/"` o `"${SRCROOT}/Pods/SDOSStencil/src/Templates/Realm/RealmParser.stencil"`|
| **`output`** |Ruta donde queremos que se generen los ficheros autogenerados. |`"${SRCROOT}/SDOSStencil/Generated/"`|

***

5. Una vez realicemos lo anterior es necesario realizar un primer `Build` al target que hemos creado. Si todo está correcto dentro de la carpeta que hayamos creado en el proyecto se generaran ficheros basándonos en los recursos que le hayamos proporcionado.
6. Es necesario añadir manualmente los recursos generados dentro de la carpeta `Generated` al proyecto, ya que solo tendremos visibilidad de estos desde el `Finder`. Para hacerlo hacer lo siguiente:
   1. Click derecho en la carpeta de `Generated`.
   2. Add files to `"{nuestro target}"`.
   3. Click en la/las carpetas que nos ha generado y pulsar en **`Add`**.


## Cómo se usa

Todos los `stencil` están preparados para parsear con ciertos parámetros, todos los ficheros a parsear deben incluir la anotación con el identificador del autogenerado que se va a usar. Esto se va a ver a continuación en el desglose de cada `stencil`.

### RealmFields

`RealmFields` es un stencil orientado para la generación de enumeradores con las propiedades que tiene un modelo Realm, esto se realiza para evitar realizar consultas, definición de `PrimaryKey` propiedades que se deben ignorar, de forma expresa, para ello vamos a usar el enumeador correspondiente a cada modelo de `Realm` que tengamos. A continuación las necesidades que tiene esta plantilla.

- Para que el generador de constantes de la clase funcione es importante tener en cuenta varios puntos, ya que sin ellos no va a generar nada de dicha clase ya que en el stencil esta definida la siguiente regla:
```
    {% for type in types.classes|annotated:"RealmFields" %}
```

  - Lo primero, es importante que nuestra entidad de `Realm` sea de tipo **`class`** ya que es una de las claves para que el generador funcione.
  - Otro de los puntos importantes es que la clase debe estar anotado con un comentario justo encima para que se detecte, este debe contener `RealmFields`. En el caso de tener varios se concatenan separados por comas.
    - Ej simple: sourcery:`RealmFields`
    - Ej multiple: sourcery:`RealmFields`,`RealmProperties`,`etc`
  - 

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

- Este `stencil` nos va a generar una carpeta dentro de nuestra carpeta `Generated` con el nombre de `RealmFields` y dentro un fichero con el nombre de `RealmFields.generated.swift`.

Tiene esta estructura:

```swift
// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

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

Si el modelo no contiene el comentario o no es de tipo **`class`** el generador no lo va a detectar y no va a generar el fichero con sus identificadores.

## Dependencias
* [Sourcery](https://github.com/krzysztofzablocki/Sourcery) - &gt;= 0.17.0

## Referencias
* https://github.com/SDOSLabs/SDOSStencil
* https://github.com/krzysztofzablocki/Sourcery
* [Guia .stencil](https://cdn.rawgit.com/krzysztofzablocki/Sourcery/master/docs/index.html)