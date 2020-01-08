- [SDOSStencil](#SDOSStencil)
  - [Introducción](#Introducci%C3%B3n)
  - [Instalación](#Instalaci%C3%B3n)
    - [Cocoapods](#Cocoapods)
  - [Cómo se usa](#C%C3%B3mo-se-usa)
    - [RealmParser](#RealmParser)
  - [Dependencias](#Dependencias)
  - [Referencias](#Referencias)

# SDOSStencil

- Changelog: https://github.com/SDOSLabs/SDOSStencil/blob/master/CHANGELOG.md

## Introducción
SDOSStencil es una herramienta orientada para la generación automática basándonos en ficheros .stencil, para ello se usa Sourcery.
Se ha usado esta forma de generación ya que a veces es necesario generar ciertos recursos para evitar los errores en ejecución y poder detectarlos en tiempo de compilación.

## Instalación

Hay que lanzar un script cada vez que se builde el proyecto para así evitar tener futuros errores en ejecución, para ello vamos a realizar los siguientes pasos.

1. En Xcode pulsamos en el proyecto, una vez en el detalle del proyecto pulsamos en el target que nos interese añadir el script.
2. Una vez estemos en el target accedemos a la sección de `Build Phases`, le damos al + que tenemos en la esquina superior izquierda.
3. Seleccionamos la opción de `New Run Script Phase`.
4. (Opcional) Renombramos el script que nos ha creado por el nombre deseado. Ej: `SDOSStencil`
5. Copiamos el siguiente script:

```sh
    "${SRCROOT}/Pods/Sourcery/bin/sourcery" --sources "SDOSStencil/RealmModels" --templates "${SRCROOT}/Pods/SDOSStencil/src/Templates/Realm/" --output "SDOSStencil/Generated/"
```

***

**`IMPORTANTE`**

La carpeta de `Generated` debe estar creada antes de ejecutar el `script`.

***

- En el parámetro de **`sources`** se coloca la ruta que queremos que el script analiza para generar recursos automáticos.
- En el parámetro de **`templates`** se coloca la ruta de los `.stencil` que queremos usar (plantillas). En este caso estamos indicando las plantillas referentes a Realm.
- En el parámetro de **`output`** va la ruta donde queremos que se generen los ficheros autogenerados.

***

6. Una vez realicemos lo anterior es necesario realizar un primer `Build` al proyecto. Si todo está correcto dentro de la carpeta que hayamos creado en el proyecto se generaran ficheros basándonos en los recursos que le hayamos proporcionado.
7. Es necesario añadir manualmente los recursos generados dentro de la carpeta `Generated` al proyecto, ya que solo tendremos visibilidad de estos desde el `Finder`. Para hacerlo hacer lo siguiente:
   1. Click derecho en la carpeta de `Generated`.
   2. Add files to `"{nuesttro target}"`.
   3. Click en la/las carpetas que nos ha generado y pulsar en **`Add`**.

### Cocoapods

Usaremos [CocoaPods](https://cocoapods.org). Hay que añadir la dependencia al `Podfile`:

```ruby
    pod `SDOSStencil`, `~&gt; 0.0.1`
```

## Cómo se usa

Todos los `stencil` están preparados para parsear con ciertos parámetros, todos los ficheros a parsear deben incluir la anotación con el identificador del autogenerado que se va a usar. Esto se va a ver a continuación en el desglose de cada `stencil`.

### RealmParser

`RealmParser` es un stencil orientado para la generación de enumeradores con las propiedades que tiene un modelo Realm, esto se realiza para evitar realizar consultas, definición de `PrimaryKey` propiedades que se deben ignorar, de forma expresa, para ello vamos a usar el enumeador correspondiente a cada modelo de `Realm` que tengamos. A continuación las necesidades que tiene esta plantilla.

- Nuestros modelos `Realm` deben incluir un comentario (_`//sourcery:RealmParser
`_) justo encima de su definición indicando que esta clase se va a usar para la autogeneración.

```swift
//sourcery:RealmParser
class DogRealm: Object {

    var name = ""
    var identifier = 0

}
```

- Este `stencil` nos va a generar una carpeta dentro de nuestra carpeta `Generated` con el nombre de `RealmProperties` y dentro un fichero con el nombre de `RealmProperties.generated.swift`.

Tiene esta estructura:

```swift
// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - DogRealmAttributes
enum DogRealmAttributes: String {
    case name = "name"
    case identifier = "identifier"
}
```

Si el modelo no contiene el comentario o no es de tipo **`class`** el generador no lo va a detectar y no va a generar el fichero con sus identificadores.

## Dependencias
* [Sourcery](https://github.com/krzysztofzablocki/Sourcery) - &gt;= 0.17.0

## Referencias
* https://github.com/SDOSLabs/SDOSStencil