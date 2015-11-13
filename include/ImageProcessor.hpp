#pragma once

#include <opencv2/opencv.hpp>
#include <vector>
#include <cstdint>
#include <cassert>

class ImageProcessor {
  
private:  
  cv::Mat image;
  cv::Mat createImChunk(const cv::Mat& src_vec, uint8_t col_panel_count, uint8_t row_panel_count,
                        uint8_t cols_panels, uint8_t cols_leds_per_panel, 
                        uint8_t rows_leds_per_panel); 
public:
  ImageProcessor();
  cv::Mat getImage(void);
  void readImage(char* fileName);
  void readImage(cv::Mat imageMat);
  std::vector<uint8_t> convertToBGRVector(void);

  
  /* a strip displays pixels left to right, but for a panel format and across LEDs
   * the image must be reshaped so the image/GIF displays correctly 
   *
   * this assumes panels are assembed left to right then top to bottom,
   * and that the "last" pixel within one panel is at its bottom right */
  void reconfigureImage(uint8_t cols_panels,
                    uint8_t rows_panels,
                    uint8_t cols_leds_per_panel,
                    uint8_t rows_leds_per_panel);
  
  //plan to add methods like getSensorData() and modifyImage()
};