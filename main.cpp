#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "circularbufferbackend.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/CircularBuffer/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    qmlRegisterType<CircularBufferBackend>("Backends",1,0,"CircularBufferBackend");
    engine.load(url);

    return app.exec();
}
