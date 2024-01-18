function [] = EstimatedTimeLeft(DataSize, Counter)

time = toc;
time = time / Counter;

clc; fprintf("%d%% finished. Time Left: %d s\n", round(100*Counter/DataSize), round(time * (DataSize - Counter)))

end