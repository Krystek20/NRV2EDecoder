import Foundation

class NRV2EDecompressor {
    
    func decompress(src: [UInt8]) -> [UInt8] {
        let reader = NRV2EBitReader(data: src, startIndex: 4)
        
        let size = src.withUnsafeBufferPointer({
            $0.baseAddress!.withMemoryRebound(to: UInt32.self, capacity: 1, { $0 })
        }).pointee
        
        var dst = [UInt8](repeatElement(0, count: Int(size)))
        var olen = 0
        var lastMOff: UInt = 1
        
        var mainLoop = true
        while mainLoop {
            var mOff: UInt = 1
            var mLen: UInt = 0
            
            if !reader.isDataAvailable {
                return dst
            }
            
            do {
                while try reader.readBit() == 1 {
                    dst[olen] = try! reader.readByte()
                    olen += 1
                }
            } catch {
                fatalError(error.localizedDescription)
            }
            
            var loop = true
            while loop {
                if !reader.isDataAvailable {
                    return dst
                }
                
                do {
                    mOff = mOff * 2 + UInt(try reader.readBit())
                    
                    if (try reader.readBit()) == 1 {
                        loop = false
                        break
                    }
                    
                    mOff = (mOff - 1) * 2 + UInt(try reader.readBit())
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
            
            if mOff == 2 {
                mOff = lastMOff
                do {
                    mLen = UInt(try reader.readBit())
                } catch {
                    fatalError(error.localizedDescription)
                }
            } else {
                do {
                    mOff = (mOff - 3) * 256 + UInt(try reader.readByte())
                } catch {
                    fatalError(error.localizedDescription)
                }
                
                if mOff == 1 {
                    mainLoop = false
                    break
                }
                mLen = (mOff ^ 1) & 1
                mOff >>= 1
                mOff += 1
                lastMOff = mOff
            }
            
            if !reader.isDataAvailable {
                return dst
            }
            
            do {
                if mLen > 0 {
                    mLen = UInt(1 + (try reader.readBit()))
                } else if try reader.readBit() == 1 {
                    mLen = UInt(3 + (try reader.readBit()))
                } else {
                    mLen += 1
                    repeat {
                        if !reader.isDataAvailable {
                            return dst
                        }
                        
                        mLen = mLen * 2 + UInt(try reader.readBit())
                        
                        if !reader.isDataAvailable {
                            return dst
                        }
                    } while try reader.readBit() == 0
                    mLen += 3
                }
            } catch {
                fatalError(error.localizedDescription)
            }
            
            mLen += UInt(mOff > 0x500 ? 1 : 0)
            
            var mPos: Int = olen - Int(mOff)
            dst[olen] = dst[mPos]
            mPos += 1
            olen += 1
            
            repeat {
                dst[olen] = dst[mPos]
                mPos += 1
                olen += 1
                mLen -= 1
            } while (mLen > 0)
        }
        
        return dst
    }
    
}
