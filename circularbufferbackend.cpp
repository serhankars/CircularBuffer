#include "circularbufferbackend.h"
#include <iostream>

CircularBufferBackend::CircularBufferBackend(QObject *parent,int capacity)
    : QObject{parent}, m_readIndex{0},m_writeIndex{0},m_length{0}, m_capacity(capacity)
{
    m_data = new int[capacity];
}

CircularBufferBackend::~CircularBufferBackend()
{
    delete[] m_data;
}

CircularBufferBackend::CircularBufferBackend(const CircularBufferBackend &rvalue)
{
    m_capacity = rvalue.capacity();
    m_data = new int[m_capacity];
    memcpy(m_data,rvalue.m_data,m_capacity*sizeof(int));
}

CircularBufferBackend &CircularBufferBackend::operator=(const CircularBufferBackend &rvalue)
{
    delete[] m_data;
    m_capacity = rvalue.capacity();
    m_data = new int[m_capacity];
    memcpy(m_data,rvalue.m_data,m_capacity*sizeof(int));
    return *this;
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
}

int CircularBufferBackend::read()
{
    if(m_length == 0)
        return -1; // empty buffer
    int result = m_data[m_readIndex];
    m_length--;
    emit lengthChanged();
    m_readIndex++;
    if(m_readIndex == m_capacity)
        m_readIndex = 0;
    emit readIndexChanged();
    return result;
}

int CircularBufferBackend::write(int value)
{
    if(m_writeIndex==m_readIndex)
    {
        if(m_length>0)
        {
            m_data[m_writeIndex] = value;
            m_readIndex++;

            if(m_readIndex == m_capacity)
                m_readIndex = 0;

            emit readIndexChanged();

            m_writeIndex++;
            if(m_writeIndex == m_capacity)
                m_writeIndex = 0;
            emit writeIndexChanged();
            return -1; // write over unread value
        }
        else
        {
            m_length++;
            emit lengthChanged();
            m_data[m_writeIndex] = value;
        }
    }
    else
    {
        m_length++;
        emit lengthChanged();
        m_data[m_writeIndex] = value;
    }

    m_writeIndex++;

    if(m_writeIndex == m_capacity)
        m_writeIndex = 0;
    emit writeIndexChanged();
    return 0;
}
