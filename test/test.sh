#!/bin/bash
sleep 5
curl -s http://passenger:10254/metrics -o result.txt

echo ""
echo "Response was:"
cat result.txt

echo ""
diff -B result.txt /test/outputs/expected.txt

if [ ! $? -eq 0 ]
then
   echo "Test: FAILURE"
   exit 1
fi

echo "Test: SUCCESS"