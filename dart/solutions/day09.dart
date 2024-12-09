import 'package:equatable/equatable.dart';

import '../utils/index.dart';

class Day09 extends GenericDay {
  Day09() : super(9);

  @override
  List<DiskEntry> parseInput() {
    final diskMap = input.asString.trim();
    return diskMap.split('').mapIndexed<DiskEntry>(
      (index, element) {
        final blockLength = int.parse(element);
        if (index.isEven) {
          return FileEntry(index ~/ 2, blockLength);
        }
        return FreeSpace(blockLength);
      },
    ).toList();
  }

  @override
  int solvePart1() {
    final diskMap = parseInput();

    List<DiskEntry> getMovedDiskMap(List<DiskEntry> diskMap) {
      final cleanDiskMap = [...diskMap].removeTrailingFreeSpace()
        ..removeWhere(
          (element) => element == const FreeSpace(0),
        );

      while (true) {
        final freeIndex = cleanDiskMap.indexWhere(
          (element) => element.isFreeSpace,
        );
        final rightMostFileIndex = cleanDiskMap.lastIndexWhere(
          (element) => !element.isFreeSpace,
        );
        if (freeIndex > rightMostFileIndex) {
          return cleanDiskMap.take(freeIndex).toList();
        }
        final freeSpace = cleanDiskMap[freeIndex] as FreeSpace;
        final rightMostFile = cleanDiskMap[rightMostFileIndex] as FileEntry;
        switch (freeSpace.blockLength - rightMostFile.blockLength) {
          case final diff when diff > 0:
            cleanDiskMap[freeIndex] = rightMostFile;
            cleanDiskMap.removeAt(rightMostFileIndex);
            cleanDiskMap.insert(freeIndex + 1, FreeSpace(diff));
          case 0:
            cleanDiskMap[freeIndex] = rightMostFile;
            cleanDiskMap.removeAt(rightMostFileIndex);
          case final diff when diff < 0:
            cleanDiskMap[freeIndex] =
                FileEntry(rightMostFile.id, freeSpace.blockLength);
            cleanDiskMap[rightMostFileIndex] =
                FileEntry(rightMostFile.id, -diff);
        }
      }
    }

    final movedDiskMap = getMovedDiskMap(diskMap);
    return movedDiskMap.checksum();
  }

  @override
  int solvePart2() {
    final diskMap = parseInput();

    List<DiskEntry> getMovedDiskMap(List<DiskEntry> diskMap) {
      final cleanDiskMap = [...diskMap].removeTrailingFreeSpace()
        ..removeWhere(
          (element) => element == const FreeSpace(0),
        );
      var biggestFileId = (cleanDiskMap.lastWhere(
        (element) => !element.isFreeSpace,
      ) as FileEntry)
          .id;
      while (biggestFileId > 0) {
        final fileEntryIndex = cleanDiskMap.indexWhere(
          (element) {
            switch (element) {
              case FileEntry(:final id):
                return id == biggestFileId;
              default:
                return false;
            }
          },
        );
        final fileEntry = cleanDiskMap[fileEntryIndex];
        final freeSpaceIndex =
            cleanDiskMap.take(fileEntryIndex).toList().indexWhere(
          (element) {
            return element is FreeSpace &&
                element.blockLength >= fileEntry.blockLength;
          },
        );
        if (freeSpaceIndex >= 0) {
          final remainingFreeSpace = FreeSpace(
            cleanDiskMap[freeSpaceIndex].blockLength - fileEntry.blockLength,
          );
          cleanDiskMap[freeSpaceIndex] = fileEntry;
          cleanDiskMap[fileEntryIndex] = FreeSpace(fileEntry.blockLength);
          if (remainingFreeSpace != const FreeSpace(0)) {
            cleanDiskMap.insert(freeSpaceIndex + 1, remainingFreeSpace);
          }
        }

        biggestFileId -= 1;
      }
      return cleanDiskMap.removeTrailingFreeSpace();
    }

    final movedDiskMap = getMovedDiskMap(diskMap);
    return movedDiskMap.checksum();
  }
}

sealed class DiskEntry extends Equatable {
  const DiskEntry(this.blockLength);

  final int blockLength;

  bool get isFreeSpace => switch (this) {
        FileEntry() => false,
        FreeSpace() => true,
      };
}

class FileEntry extends DiskEntry {
  const FileEntry(this.id, super.blockLength);

  final int id;

  int checksum(int index) {
    return List<int>.generate(
      blockLength,
      (i) {
        return (i + index) * id;
      },
      growable: false,
    ).fold(
      0,
      (previousValue, element) {
        return previousValue + element;
      },
    );
  }

  @override
  List<Object?> get props => [blockLength, id];
}

class FreeSpace extends DiskEntry {
  const FreeSpace(super.blockLength);

  @override
  List<Object?> get props => [blockLength];
}

extension DiskMapX on List<DiskEntry> {
  List<DiskEntry> removeTrailingFreeSpace() {
    if (!last.isFreeSpace) {
      return [...this];
    }
    return reversed
        .skipWhile(
          (value) {
            return value.isFreeSpace;
          },
        )
        .toList()
        .reversed
        .toList();
  }

  int checksum() {
    final correctIndexed = mapIndexed<(int, DiskEntry)>(
      (index, element) {
        final correctIndex = take(index).fold(
          0,
          (previousValue, diskEntry) {
            return previousValue + diskEntry.blockLength;
          },
        );
        return (correctIndex, element);
      },
    );
    return correctIndexed.fold(
      0,
      (previousValue, element) {
        final (index, diskEntry) = element;
        return switch (diskEntry) {
          FileEntry() => previousValue + diskEntry.checksum(index),
          FreeSpace() => previousValue,
        };
      },
    );
  }
}
