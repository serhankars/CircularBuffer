#include "circularbufferbackend.h"
#include <iostream>

CircularBufferBackend::CircularBufferBackend(QObject *parent,int capacity)
    : QAbstractListModel{parent}, m_readIndex{0},m_writeIndex{0},m_length{0}, m_capacity(capacity)
{
}

int CircularBufferBackend::readIndex() const
{
    return m_readIndex;
}

int CircularBufferBackend::writeIndex() const
{
    return m_writeIndex;
}

int CircularBufferBackend::length() const
{
    return m_length;
}

int CircularBufferBackend::capacity() const
{
    return m_capacity;
}

void CircularBufferBackend::setCapacity(int capacity)
{
    m_capacity = capacity;
    m_data.resize(capacity);
}

QHash<int, QByteArray> CircularBufferBackend::roleNames() const
{
    static QHash<int,QByteArray> mapping{
        {DataRole,"data"}
    };

    return mapping;
}

int CircularBufferBackend::read()
{
    if(m_length == 0)
        return -1; // empty buffer
    int result = m_data[m_readIndex];
    m_length--;
    emit lengthChanged();
    m_readIndex = (m_readIndex + 1) % m_capacity;
    emit readIndexChanged();
    return result;
}

int CircularBufferBackend::write(int value)
{
    int modifiedIndex = m_writeIndex;
    bool overwritten = false;
    if(m_writeIndex==m_readIndex && m_length>0)
    {
        overwritten = true;
    }

    m_data[m_writeIndex] = value;
    emit dataChanged(index(m_writeIndex),index(m_writeIndex),{DataRole});
    m_writeIndex = (m_writeIndex + 1) % m_capacity;
    emit writeIndexChanged();

    if(overwritten)
    {
        m_readIndex = (m_readIndex + 1) % m_capacity;
        emit readIndexChanged();
    }
    else
    {
        m_length++;
        emit lengthChanged();
    }

    return overwritten?-1:0;
}
