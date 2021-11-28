## Add Middlewares in IRIS
This project allows you to add Middlewares to routes or groups of routes, create and specify your application's Middlewares, performing custom security treatments on all requests.
Specify Middleware for specific classmethod or exit when necessary.

Handle request headers, create your own rules and validations even before running endpoints, sanitize your requests, and more

## How Middlewares Work

Middleware are coded in the behavioral design pattern known as "chain of responsibility" allows you to pass requests through a chain of handlers. Upon receiving an order, each handler decides whether to process the order or pass it on to the next handler in the chain.

<img src="https://raw.githubusercontent.com/Davi-Massaru/middlewares/master/README/domino.gif"></img>

All chains have a unique responsibility and most of them must return void, if something happens different than expected, the chain be broken and an exception is usually thrown.

## Defining Middleware

You can define your middleware in the package of your choice, in this project there are some examples in the dc.Middleware package, should always extend from ```dc.Chain.Middleware``` and have the ```Method Handle``` implement.

```
Class dc.Middleware.Middleware1 Extends dc.Chain.Middleware
{

    Method Handle()
    {
        Do ..Next()
    }

}
```

The method Handle will always be executed when the middleware is called and this method need to call ```DO ..Next()``` which will call the next chain middleware.

If needed, call ```..Abort()```, this method will broke the chain and throw an MiddlewareException.

## Custom Middleware Exception

Set the #AbortCode & #AbortMessage parameters to customize a specific Middleware exception.

they have as default value AbortCode = { ##class(%CSP.REST).#HTTP401UNAUTHORIZED } and AbortMessage = "Unauthorized"

```
    Parameter AbortCode = {##class(%CSP.REST).#HTTP403FORBIDDEN};

    Parameter AbortMessage = "Forbidden";
```
When Do Abort the response will be your status code set to ```#AbortCode``` and a content define with { "Message" : ( ```#AbortMessage``` ) }

## Middleware group on Dispatch

Create a class that Extends dc.Dispatch this class enable middlewares in your Dispatch class.

Overwrite the ClassMethod WithMiddlewares() to return a list of Middlewares you want to invoke whenever a request occurs. They are will be called in the order given.

```
Class cd.Api.MainDispatch Extends dc.Dispatch
{

ClassMethod WithMiddlewares() As %List
{
    return $LB( "dc.Middleware.Middleware1", "dc.Middleware.Middleware2", "dc.Middleware.Middleware3")
}

}

```

The dc.Dispatch called WithMiddlewares on OnPreDispatch, to be executed for EVERY request, if abort occurs, pContinue is set to 0 and the request is not processed.

## Calling Middleware by classMethods

You can also define which Middlewares you want to call, informing a annotation on Description of Method.

1. @with_middlewares() Defines the Middlewares that will be called when this class Method is requested. Adding to the end of the list of ```ClassMethod WithMiddlewares```.

2. @without_middlewares() Skip the Middlewares that do not want to execute this specific request, the Middlewares informed will be excluded from list of ```ClassMethod WithMiddlewares```.

```
Class cd.Api.MainDispatch Extends dc.Dispatch
{

ClassMethod WithMiddlewares() As %List
{
    return $LB(
        "dc.Middleware.Middleware1",
        "dc.Middleware.Middleware2",
        "dc.Middleware.Middleware3"
    )
}

/// @with_middlewares( dc.Middleware.Middleware4, dc.Middleware.Middleware5 )
/// @without_middlewares(dc.Middleware.Middleware1 , dc.Middleware.Middleware2 )
ClassMethod Ping() As %Status
{
    Write { "Say" : "Pong" }.%ToJSON()
    Return $$$OK
}

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/ping" Method="GET" Call="Ping" />
</Routes>
}

}
```
In this example, only the Middlewares ```dc.Middleware.Middleware3, dc.Middleware.Middleware4, dc.Middleware.Middleware5``` will be executed because the ```dc.Middleware.Middleware1 , dc.Middleware.Middleware2``` were removed and ```the dc.Middleware.Middleware4, dc.Middleware.Middleware5``` were append


## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation 

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/Davi-Massaru/middlewares.git
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container with your project:

```
$ docker-compose up -d
```