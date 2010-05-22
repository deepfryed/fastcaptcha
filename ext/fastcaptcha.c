#include <ruby.h>
#include <ruby/encoding.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <opencv/cxcore.h>
#include <opencv/highgui.h>

#define ID_CONST_GET rb_intern("const_get")
#define CONST_GET(scope, constant) (rb_funcall(scope, ID_CONST_GET, 1, rb_str_new2(constant)))

static VALUE rb_cFC;
static VALUE eLoadError;
static VALUE eRuntimeError;
static VALUE eArgumentError;

#define SILLY   1
#define EASY    2
#define MEDIUM  3
#define HARD    4

VALUE rb_captcha_image(VALUE self, VALUE string, VALUE lv) {
    CvScalar c;
    CvPoint *pts, pt1, pt2;
    CvFont font[5];
    char text[2];
    int i, x, y;
    double skew = 1;
    IplImage *img;
    CvMat *out;
    char *cstr = RSTRING_PTR(string);
    int W=strlen(cstr)*30+20;
    int H=50;
    int level = NUM2INT(lv);
    img = cvCreateImage(cvSize(W, H), 8, 3);
    pts = (CvPoint *)malloc(sizeof(CvPoint)*strlen(cstr));
    for (i = 0; i < 5; i++) {
        cvInitFont(&font[i], CV_FONT_HERSHEY_PLAIN, 2.5, 2.5, skew, 2, 8);
        skew += 0.5;
    }
    cvSet(img, cvScalarAll(255), 0);
    if (level >= EASY && level < HARD) {
        for (i = 0; i < W; i += 5) {
            c = CV_RGB(rand()%50 + 180, rand()%50 + 180, rand()%50 + 180);
            cvLine(img, cvPoint(i, 0), cvPoint(i, H), c, rand()%2+1, 8, 0);
        }
        for (i = 0; i < H; i += 5) {
            c = CV_RGB(rand()%50 + 180, rand()%50 + 180, rand()%50 + 180);
            cvLine(img, cvPoint(0, i), cvPoint(W, i), c, rand()%2+1, 8, 0);
        }
    }
    if (level >= MEDIUM) {
        for (i = 0; i < 10; i++) {
            c = CV_RGB(rand()%50 + 155, rand()%50 + 155, rand()%50 + 155);
            cvCircle(img, cvPoint(rand()%(W>>1)+10, rand()%(H>>1)+10), rand()%10 + 5, c, 1, 8, 0);
        }
        for (i = 0; i < 10; i++) {
            c = CV_RGB(rand()%50 + 200, rand()%50 + 200, rand()%50 + 200);
            pt1 = cvPoint(rand()%W, rand()%H);
            pt2 = cvPoint(rand()%W, rand()%H);
            cvLine(img, pt1, pt2, c, 2, 8, 0);
        }
    }
    x = rand()%40;
    memset(text, 0, 2);
    for (i = 0; i < strlen(cstr); i++) {
        y = (H>>1) - (10 - rand()%10) + 20;
        pts[i] = cvPoint(x, y - rand()%20);
        text[0] = cstr[i];
        c = CV_RGB(rand()%50 + 120, rand()%50 + 120, rand()%50 + 120);
        cvPutText(img, text, cvPoint(x, y), &font[i%5], c);
        x += 25;
    }
    if (level >= HARD) {
        for (i = 0; i < strlen(cstr) - 1; i++) {
            c = CV_RGB(rand()%50 + 150, rand()%50 + 150, rand()%50 + 150);
            cvLine(img, pts[i], pts[i+1], c, 2, 8, 0);
        }
    }
    out = cvEncodeImage(".png", img, 0);
    VALUE imgdata = rb_str_new((const char *)out->data.ptr, out->step);
    cvReleaseImage(&img);
    cvReleaseMat(&out);
    free(pts);
    return imgdata;
}

/* init */

void Init_fastcaptcha(void) {
    srand(time(NULL));
    eLoadError     = CONST_GET(rb_mKernel, "LoadError");
    eRuntimeError  = CONST_GET(rb_mKernel, "RuntimeError");
    eArgumentError = CONST_GET(rb_mKernel, "ArgumentError");
    rb_cFC = rb_define_class("FastCaptcha", rb_cObject);
    rb_define_method(rb_cFC, "image", rb_captcha_image, 2);
}
