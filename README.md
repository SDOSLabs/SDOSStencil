- [SDOSStencil](#SDOSStencil)
  - [Introducción](#Introducci%C3%B3n)
  - [Instalación](#Instalaci%C3%B3n)
    - [Cocoapods](#Cocoapods)
  - [Cómo se usa](#C%C3%B3mo-se-usa)
  - [Dependencias](#Dependencias)
  - [Referencias](#Referencias)

# SDOSStencil

- Changelog: https://github.com/SDOSLabs/SDOSStencil/blob/master/CHANGELOG.md

## Introducción
SDOSStencil es una herramienta orientada para la generación automática basándonos en ficheros .stencil, para ello se usa Sourcery.
Se ha usado esta forma de generación ya que a veces es necesario generar ciertos recursos para evitar los errores en ejecución y poder detectarlos en tiempo de compilación.

## Instalación

### Cocoapods

Usaremos [CocoaPods](https://cocoapods.org). Hay que añadir la dependencia al `Podfile`:

```ruby
pod 'SDOSStencil', '~> 0.0.1' 
```

## Cómo se usa

## Dependencias
* [Sourcery](https://github.com/krzysztofzablocki/Sourcery) - >= 0.17.0

## Referencias
* https://github.com/SDOSLabs/SDOSStencil
