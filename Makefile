CXXFLAGS = -g -std=c++11 -fno-exceptions
CXXFLAGS_CV = `pkg-config --cflags opencv` 
CXXFLAGS_MAGICK = -fopenmp -DMAGICKCORE_HDRI_ENABLE=0 -DMAGICKCORE_QUANTUM_DEPTH=16 -I/usr/local/include/ImageMagick-6 
LIBS_CV = `pkg-config --libs opencv`
LIBS_WPI = -lwiringPi
LIBS_MAGICK = -L/usr/local/lib -lMagick++-6.Q16 -lMagickWand-6.Q16 -lMagickCore-6.Q16
IDIR=./include
SDIR=./src
TEST_DIR=./tests
OBJ_DIR=./obj
BIN_DIR=./bin
APDS9960_DIR=./apds-9960-raspberry-pi-library


TARGETS = testLPD8806 playGIF GestureTest testImageProcessor 

all: $(TARGETS)


testImageProcessor: $(OBJ_DIR)/ImageProcessor.o $(OBJ_DIR)/testImageProcessor.o 
	g++ -o $(BIN_DIR)/$@ $^ -I$(IDIR) $(CXXFLAGS) $(CXXFLAGS_CV) $(LIBS_CV) 

testLPD8806: $(OBJ_DIR)/LPD8806.o $(OBJ_DIR)/testLPD8806.o 
	g++ -o $(BIN_DIR)/$@ $^ -I$(IDIR) $(CXXFLAGS) $(LIBS_WPI) 

playGIF: $(OBJ_DIR)/SensorHandler.o $(OBJ_DIR)/APDS9960_RPi.o $(OBJ_DIR)/ImageProcessor.o $(OBJ_DIR)/GridLED.o $(OBJ_DIR)/LPD8806.o $(OBJ_DIR)/Controller.o $(OBJ_DIR)/playGIF.o 
	g++ -o $(BIN_DIR)/$@ $^ -I$(IDIR) -I$(APDS9960_DIR) $(CXXFLAGS) $(CXXFLAGS_MAGICK) $(LIBS_MAGICK) $(CXXFLAGS_CV) $(LIBS_CV) $(LIBS_WPI)

GestureTest: $(OBJ_DIR)/APDS9960_RPi.o $(OBJ_DIR)/GestureTest.o
	g++ -o $(BIN_DIR)/$@ $^ -I$(IDIR) $(CXXFLAGS) $(LIBS_WPI)


$(OBJ_DIR)/ImageProcessor.o: $(SDIR)/ImageProcessor.cpp $(IDIR)/SensorHandler.hpp $(IDIR)/ImageProcessor.hpp
	g++ -c $< -o $@ -I$(IDIR) -I$(APDS9960_DIR) $(CXXFLAGS) $(CXXFLAGS_CV) $(LIBS_CV)

$(OBJ_DIR)/testImageProcessor.o: $(TEST_DIR)/testImageProcessor.cpp $(IDIR)/ImageProcessor.hpp 
	g++ -c $< -o $@ -I$(IDIR) -I$(APDS9960_DIR) $(CXXFLAGS) $(CXXFLAGS_CV) $(LIBS_CV) 

$(OBJ_DIR)/GridLED.o: $(SDIR)/GridLED.cpp $(IDIR)/GridLED.hpp $(IDIR)/LPD8806.hpp
	g++ -c $< -o $@ -I$(IDIR) $(CXXFLAGS) $(LIBS_WPI)

$(OBJ_DIR)/LPD8806.o: $(SDIR)/LPD8806.cpp $(IDIR)/LPD8806.hpp 
	g++ -c $< -o $@ -I$(IDIR) $(CXXFLAGS) $(LIBS_WPI)

$(OBJ_DIR)/testLPD8806.o: $(TEST_DIR)/testLPD8806.cpp $(IDIR)/LPD8806.hpp 
	g++ -c $< -o $@ -I$(IDIR) $(CXXFLAGS) $(LIBS_WPI)

$(OBJ_DIR)/SensorHandler.o: $(SDIR)/SensorHandler.cpp $(APDS9960_DIR)/APDS9960_RPi.h
	g++ -c $< -o $@ -I$(IDIR) -I$(APDS9960_DIR) $(CXXFLAGS) $(LIBS_WPI)

$(OBJ_DIR)/Controller.o: $(SDIR)/Controller.cpp $(IDIR)/SensorHandler.hpp $(IDIR)/ImageProcessor.hpp $(IDIR)/GridLED.hpp
	g++ -c $< -o $@ -I$(IDIR) -I$(APDS9960_DIR) $(CXXFLAGS) $(CXXFLAGS_MAGICK) $(LIBS_MAGICK) 

$(OBJ_DIR)/playGIF.o: $(SDIR)/playGIF.cpp $(IDIR)/Controller.hpp 
	g++ -c $< -o $@ -I$(IDIR) -I$(APDS9960_DIR) $(CXXFLAGS) $(CXXFLAGS_MAGICK) $(LIBS_MAGICK)

$(OBJ_DIR)/APDS9960_RPi.o: $(APDS9960_DIR)/APDS9960_RPi.cpp $(APDS9960_DIR)/APDS9960_RPi.h
	g++ -c $< -o $@ -I$(IDIR) -I$(APDS9960_DIR) $(CXXFLAGS) $(LIBS_WPI)

$(OBJ_DIR)/GestureTest.o: $(APDS9960_DIR)/GestureTest.cpp $(APDS9960_DIR)/APDS9960_RPi.h
	g++ -c $< -o $@ -I$(IDIR) -I$(APDS9960_DIR) $(CXXFLAGS) $(LIBS_WPI)


.PHONY: clean

clean:
	rm -f $(OBJ_DIR)/* && cd $(BIN_DIR) && rm -f $(TARGETS) 
