-- Quick and dirty script of NHocr-OCRopus(0.2) bridge
--   by Hideaki Goto on Sep. 26, 2008
--
-- Example of using NHocr (rec_line) as a line recognizer
-- together with OCRopus layout analysis.
--
-- Installation:
--   Put this Lua script into
--    ${OCROPUS_INSTALLDIR}/share/ocropus/scripts/


if #arg < 1 then
    print("Usage: ocroscript rec-nhocr input_image_file > output.euc-jp.txt ")
    os.exit(1)
end

pages = Pages()
pages:parseSpec(arg[1])

segmenter = make_SegmentPageByRAST()
page_image = bytearray()
page_segmentation = intarray()
line_image = bytearray()

while pages:nextPage() do
   pages:getBinary(page_image)
   segmenter:segment(page_segmentation,page_image)
   regions = RegionExtractor()
   regions:setPageLines(page_segmentation)
   for i = 1,regions:length()-1 do
      regions:extract(line_image,page_image,i,1)
      write_pgm("line.pgm", line_image)
      system("/opt/nhocr/bin/rec_line -o - line.pgm ; rm line.pgm")
   end
end
