import java.util.ArrayList;
import java.util.Scanner;
import java.io.File;

import javax.swing.JFileChooser;

ArrayList<PLine> lineList;
ArrayList<Point> pointList;

Point camCent;
float camRad;
float camHorizAng;
float camVertAng;
float orientation;
boolean showGnoman;
int sweight;
File file;

int needFile = 1; 

void setup() {
	lineList = new ArrayList<PLine>();
	pointList = new ArrayList<Point>();
	
	camCent = new Point(0, 0, 0);
	
	camRad = 330;
	camHorizAng = 0.1;
	camVertAng = 0.1;
	
	orientation = 1.0;
	showGnoman = true;
	
	sweight = 1;
	
	textSize(32);
	
	size (800, 800, P3D);
	fill(204);
}

void draw() {
	lights();
	background(230);
		
	float eyeX = camCent.x + camRad * sin(camVertAng) * cos(camHorizAng);
	float eyeY = camCent.y + camRad * sin(camVertAng) * sin(camHorizAng);
	float eyeZ = camCent.z + camRad * cos(camVertAng);
	
	if(abs(camVertAng) % (2 * PI) > (PI)) orientation = -1;
	else orientation = 1;
	
	camera(eyeX, eyeY, eyeZ,
			camCent.x, camCent.y, camCent.z,
			0.0,0.0,orientation);
	
	
	strokeWeight(sweight);
	
	if(showGnoman) {
		strokeWeight(4);
		stroke(0);
		line(0,0,0,50,0,0);
		text("X",50,0,0);
		line(0,0,0,0,50,0);
		text("Y",0,50,0);
		line(0,0,0,0,0,50);
		text("Z",0,0,50);
	}
	
	strokeWeight(sweight);
	int incr = 0;
	if(!lineList.isEmpty()) incr = 255 / lineList.size();
	int r = 0;
	
	for(PLine l : lineList) {
		drawPLine(l);
	}
	
	for(Point p: pointList) {
		point(p.x, p.y, p.z);
	}
	
}

void drawPLine(PLine l) {
	if(l.size() >= 2)	{
		for(int i = 0; i < l.size() - 1; i++) {
			Point p1 = l.get(i);
			Point p2 = l.get(i+1);
			line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
		}		
	}
}

void mouseWheel(MouseEvent event) {
	float e = event.getCount();
	camRad += e;
}

void keyPressed() {
	//ROTATE
	if(key == 'w'){
		camVertAng += 0.1;
		println("VertAng: " + camVertAng);
	}
	if(key == 's'){
		camVertAng -= 0.1;
		println("VertAng: " + camVertAng);
	}
	if(key == 'a'){
		camHorizAng += 0.1;
		println("HorizAng: " + camHorizAng);
	}
	if(key == 'd'){
		camHorizAng -= 0.1;
		println("HorizAng: " + camHorizAng);
	}
	
	if(key == 'r'){
		reloadFile();
	}
	
	if(key == 'f'){
		loadFile();
	}
	
	if(key == 'v'){
		showGnoman = !showGnoman;
	}
	
	if(key =='t') {
		sweight += 1;
	}
	
	if(key == 'g') {
		sweight -= 1;
	}
	
	//ZOOM
	if(key == 'q'){
		camRad += 1.0;
		println("Rad: " + camRad);
	}
	if(key == 'e') {
		camRad -= 1.0;
		println("Rad: " + camRad);
	}
	
	//SHIFT VIEW
	if(key == CODED) {
		if(keyCode == LEFT) {
			camCent.x -= 5.0;
			println("CamX: " + camCent.x);
		}
		if(keyCode == RIGHT) {
			camCent.x += 5.0;
			println("CamX: " + camCent.x);
		}
		if(keyCode == UP) {
			camCent.y -= 5.0;
			println("CamY: " + camCent.y);
		}
		if(keyCode == DOWN) {
			camCent.y += 5.0;
			println("CamY: " + camCent.y);
		}
	}
}

void loadFile() {
	lineList.clear();
	
	JFileChooser chooser = new JFileChooser();
    int returnVal = chooser.showOpenDialog(null);
    if(returnVal == JFileChooser.APPROVE_OPTION) {
        println("You chose to open this file: " + chooser.getSelectedFile().getName());
		file = chooser.getSelectedFile();
		reloadFile();
    }
	
	
}

void reloadFile() {
	lineList.clear();
	pointList.clear();
	try {
			int i = 1;
			Scanner sc = new Scanner(file);
			println("trying to open csv...");
			String ts;
			int ln = 0;
			int pn = 0;
			while(sc.hasNext()) {
				ts = sc.next();
				if (ts.equals("<point>")) {
					Point p = new Point();
					
					p.x = 50*sc.nextFloat();
					p.y = 50*sc.nextFloat();
					p.z = 50*sc.nextFloat();
					
					pointList.add(p);
				}
				if (ts.equals("<line>")) {
					PLine l = new PLine();
					
					println("adding line: " + ln++);
					
					while(sc.hasNextFloat()) {
						
						println("	point: " + pn++);
						
						Point p = new Point();
						
						p.x = 50*sc.nextFloat();
						p.y = 50*sc.nextFloat();
						p.z = 50*sc.nextFloat();
						
						l.add(p);
					}
					
					pn = 0;
					lineList.add(l);
				}
			}
		} catch (Exception e) { 
			println("File exception");
			if(e.getMessage() != null) println(e.getMessage());
			e.printStackTrace();
		}
}


