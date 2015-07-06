# maxwell render

MX_CPPFLAGS=-D_MACOSX -DCOMPILER_GCC  -I../../sdk/h 
MX_LDFLAGS=-L../../sdk/lib -lmxs -framework Cocoa  -lz -lxml2 

# compiler setting
CPP=g++
# I_SYSROOT=-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk
CPPFLAGS=-c -Wall $(MX_CPPFLAGS) 
LDFLAGS =$(MX_LDFLAGS)

# LDFLAGS=$(I_SYSROOT) -lc++ -framework Cocoa -lxml2 -framework OpenGL  -framework QTKit -framework WebKit -framework QuartzCore -framework Quartz -lz -stdlib=libc++

# targets setting
SOURCES=$(wildcard *.cpp)
OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=FixArrowayTexturesScale


	
#create app
# APP_PATH=./bin/$(EXECUTABLE).app

# print:
# 	@echo $(SOURCES)
# 	@echo $(OBJECTS)
# 	@echo $(APP_PATH)/Contents/MacOS/$(EXECUTABLE)
# 	@echo "./$(EXECUTABLE)" "$(APP_PATH)/Contents/MacOS/$(EXECUTABLE)"


# all: $(SOURCES) $(EXECUTABLE) 
# 	SetFile -t APPL $(EXECUTABLE)
# 	mkdir -p $(APP_PATH)/Contents
# 	mkdir -p $(APP_PATH)/Contents/MacOS
# 	mkdir -p $(APP_PATH)/Contents/Resources
# 	mkdir -p $(APP_PATH)/Contents/Resources/videos
# 	cp -f ./$(EXECUTABLE) $(APP_PATH)/Contents/MacOS/$(EXECUTABLE)

all: $(SOURCES)  $(EXECUTABLE)
	@echo $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS) 
	$(CPP) $(LDFLAGS) $(OBJECTS) -o $@


.cpp.o: 
	$(CPP) $(CPPFLAGS) $< -o $@
	
clean:
	rm -f ./*.o
	rm -f $(EXECUTABLE)
	rm -r $(APP_PATH)
	
%: 
	$(CPP) $(LDFLAGS)  $*.o -o $*