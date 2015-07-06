#include <stdio.h>

#include "maxwell.h"

//data
#define MAX_NAME_LEN 64
typedef struct ArrowayTexture{
	char type[MAX_NAME_LEN];
	char name[MAX_NAME_LEN];
	int index;
	int imgWidth; 
	int imgHeight;
	float realWidth;
} ArrowayTexture;

#define NUMB_TEXTURES 59
ArrowayTexture gtextures[NUMB_TEXTURES] = {
	{"Boards","boards",1,8000,2500,5},
	{"Boards","boards",2,3800,3800,3.8},
	{"Boards","boards",4,8000,3600,4},
	{"Bricks","bricks",3,2500,2100,8},
	{"Bricks","bricks",5,4200,1800,2.8},
	{"Bricks","bricks",6,2200,3000,2.6},
	{"Bricks","bricks",8,7000,7000,4},
	{"Bricks","bricks",9,6000,2800,2.4},
	{"Bricks","bricks",10,6700,2600,5},
	{"Bricks","bricks",14,8000,5600,5},
	{"Bricks","bricks",17,3500,2000,5},
	{"Bricks","bricks",18,9000,5700,4},
	{"Bricks","bricks",20,12000,2700,5.3},
	{"Concrete","concrete",1,3600,3600,1},
	{"Concrete","concrete",2,1300,1300,1},
	{"Concrete","concrete",3,3000,6000,1},
	{"Metal","metal structure",1,1900,1600,2},
	{"Metal","metal structure",2,4000,1500,5.5},
	{"Metal","metal structure",3,2500,2500,1.5},
	{"Metal","metal structure",4,2100,2100,2},
	{"Metal","metal structure",5,2100,2100,2},
	{"Metal","metal structure",7,4800,5800,2},
	{"Pavement","pavement",2,3000,3000,5},
	{"Pavement","pavement",3,5000,5000,6},
	{"Pavement","pavement",4,4200,4200,1.2},
	{"Pavement","pavement",5,4200,4200,1.2},
	{"Pavement","pavement",6,4200,4200,1.2},
	{"Plaster","plaster",1,1500,1500,2},
	{"Plaster","plaster",2,1500,1500,1.5},
	{"Plaster","plaster",3,1600,1600,2},
	{"Plaster","plaster",5,1800,1800,2},
	{"Plaster","plaster",6,12000,4700,4.6},
	{"Plaster","plaster",7,1200,1200,2},
	{"Plaster","plaster",8,6000,4900,4.5},
	{"Plaster","plaster",9,1700,1700,2.5},
	{"Plaster","plaster",10,1700,1700,2.5},
	{"Plaster","plaster",11,1500,1500,2},
	{"Plaster","plaster",18,2600,2600,4},
	{"Plaster","plaster",26,3000,3600,0.8},
	{"Tiles","tiles",1,2000,3100,1.6},
	{"Tiles","tiles",2,2400,6000,0.8},
	{"Tiles","tiles",3,4000,4000,1.5},
	{"Tiles","tiles",4,3800,6900,4},
	{"Tiles","tiles",5,5000,5000,7},
	{"Tiles","tiles",6,5000,5000,8},
	{"Tiles","tiles",7,5000,5000,2},
	{"Tiles","tiles",8,7500,3500,4},
	{"Tiles","tiles",9,5600,5600,3.2},
	{"Tiles","tiles",10,4000,4000,8},
	{"Tiles","tiles",11,5000,5000,6},
	{"Tiles","tiles",12,6000,6000,8},
	{"Tiles","tiles",13,5000,5000,7.5},
	{"Tiles","tiles",14,5000,5000,5},
	{"Tiles","tiles",15,5000,5000,6},
	{"Tiles","tiles",16,5000,5000,5},
	{"Tiles","tiles",17,8000,8000,8},
	{"Tiles","tiles",18,5000,5000,6},
	{"Tiles","tiles",19,5000,5000,6.5},
	{"Tiles","tiles",20,6000,6000,8}
};

byte error_callback (byte iserror, const char *pmethod, const char *message, const void *data)
{
	printf("%d, %s", iserror, message);
	return 0;
}


int main(){

	char dn_input[] = "/Users/Jing/Dropbox/3DMotion/3DMotionDB/exps/round02/GroundTesting/res/materials";
	char dn_output[] = "/Users/Jing/Dropbox/3DMotion/3DMotionDB/exps/round02/GroundTesting/mxm";

	char fn_org_mxm[512];
	char fn_dst_mxm[512];
	char cur_mat_name[64];
	
	CtextureMap ** maps = 0;
	dword nMaps = 0;
	int i, j;
	float u, v; // u -> height, v-> width


	// Create Maxwell instance
	Cmaxwell *maxwell = new Cmaxwell (error_callback);

	for (i=0; i < NUMB_TEXTURES; i++){
		sprintf(cur_mat_name, "%s-%03d", gtextures[i].name, gtextures[i].index);
		sprintf(fn_org_mxm, "%s/%s/Maxwell Render 2.x/%s.mxm", dn_input, gtextures[i].type, cur_mat_name);
		sprintf(fn_dst_mxm, "%s/%s.mxm", dn_output, cur_mat_name);

		printf("Processing(%d/%d): %s\r\n", i, NUMB_TEXTURES, fn_org_mxm);

		u =  gtextures[i].realWidth / 1.0;
		v = (gtextures[i].realWidth  * gtextures[i].imgHeight) / (1.0 * gtextures[i].imgWidth) ;
	
		// create material
		Cmaxwell::Cmaterial material = maxwell->createMaterial(cur_mat_name, true);
		
		//read origin material
		material.read(fn_org_mxm);
		maps = material.getMaps(nMaps, 1);
		printf("%s: %d\r\n", material.getName(), nMaps);
		for (j=0; j < nMaps; j++){
			maps[j]->uIsTiled=1;
			maps[j]->vIsTiled=1;
			maps[j]->useAbsoluteUnits  = 1;
			maps[j]->scale.assign(u, v);
		}

		// save material
		material.write(fn_dst_mxm);

		delete maps;
		printf("Write new material to : %s\r\n", fn_dst_mxm);
	}
	
	// free memory and delete
	maxwell->freeScene();
	delete maxwell;
	
	printf("Finish processing\r\n");
	return 1;
}
