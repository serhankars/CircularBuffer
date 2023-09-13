#ifndef CIRCULARBUFFERBACKEND_H
#define CIRCULARBUFFERBACKEND_H

#include <QObject>
#include <QAbstractListModel>

class CircularBufferBackend : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int readIndex READ readIndex NOTIFY readIndexChanged)
    Q_PROPERTY(int writeIndex READ writeIndex NOTIFY writeIndexChanged)
    Q_PROPERTY(int capacity READ capacity WRITE setCapacity FINAL)
    Q_PROPERTY(int length READ length NOTIFY lengthChanged)

public:
    explicit CircularBufferBackend(QObject *parent = nullptr, int capacity=1);

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
    QList<int> m_data;

    // QAbstractItemModel interface
public:
    enum Roles{ DataRole = Qt::UserRole};

    int rowCount(const QModelIndex &parent) const
    {
        if(parent.isValid())
            return 0;

        return m_capacity;
    }
    QVariant data(const QModelIndex &index, int role) const
    {
        if(!index.isValid())
            return QVariant();

        const int& data = m_data.at(index.row());

        if(role == DataRole)
            return data;

        return QVariant();
    }
    QHash<int, QByteArray> roleNames() const;
};

#endif // CIRCULARBUFFERBACKEND_H
