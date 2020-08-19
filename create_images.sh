#!/bin/bash
git checkout master
echo test >> test
git add .
git commit -m 'generate image'
git push origin master

git checkout dev
echo test >> test
git add .
git commit -m 'generate image'
git push origin dev

git checkout staging
echo test >> test
git add .
git commit -m 'generate image'
git push origin staging



