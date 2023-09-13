#ifndef CIRCULARBUFFERBACKEND_H
#define CIRCULARBUFFERBACKEND_H

#include <QObject>

class CircularBufferBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int readIndex READ readIndex NOTIFY readIndexChanged)
    Q_PROPERTY(int writeIndex READ writeIndex NOTIFY writeIndexChanged)
    Q_PROPERTY(int capacity READ capacity WRITE setCapacity)
    Q_PROPERTY(int length READ length NOTIFY lengthChanged)

public:
    explicit CircularBufferBackend(QObject *parent = nullptr, int capacity=1);
    ~CircularBufferBackend();
    CircularBufferBackend(const CircularBufferBackend& rvalue);
    CircularBufferBackend& operator=(const CircularBufferBackend& rvalue);

    int readIndex() const;
    int writeIndex() const;
    int length() const;
    int capacity() const;
    void setCapacity(int capacity);

    Q_INVOKABLE int read();
    Q_INVOKABLE int write(int value);

signals:

    void readIndexChanged();
    void writeIndexChanged();
    void lengthChanged();

private:
    int m_readIndex;
    int m_writeIndex;
    int m_capacity;
    int m_length;
    int* m_data;
};

#endif // CIRCULARBUFFERBACKEND_H
