from keras.models import Sequential
from keras.layers import LSTM, Dense
import numpy as np

print('Loading data...')
# OISST.shape = (1830, 18400)
OISST = np.loadtxt('data/OISST_19811101-20161116.dat')
# PREC.shape = (1688, 9)
PREC = np.loadtxt('data/zones_Prec_weekly_19811101-20140228.dat')

X = OISST[:PREC.shape[0],:]
X = X.reshape(X.shape[0], 80, 230)
Y = PREC



# expected input data shape: (batch_size, timesteps, data_dim)
model = Sequential()
model.add(LSTM(32, return_sequences=True,
               input_shape=(80, 230)))  # returns a sequence of vectors of dimension 32
model.add(LSTM(32, return_sequences=True))  # returns a sequence of vectors of dimension 32
model.add(LSTM(32))  # return a single vector of dimension 32
model.add(Dense(9, activation='softmax'))

model.compile(loss='categorical_crossentropy',
              optimizer='rmsprop',
              metrics=['accuracy'])


model.fit(X, Y,
          batch_size=64, nb_epoch=5)



